require 'json'
require 'json-schema'

module FlipTheSwitch
  module Reader
    class Features
      def initialize(input, environment)
        @input = input
        @environment = environment
      end

      def features
        raise Error::InvalidFile.new(input_file) unless valid_file?
        raise Error::InvalidEnvironment.new(environment) unless environments_by_name.has_key?(environment)
        inherited_environment(environment).features
      end

      private
      attr_reader :input, :environment

      INHERITS_KEY = 'inherits_from'
      ENABLED_KEY = 'enabled'
      DESCRIPTION_KEY = 'description'

      def inherited_environment(env_name)
        inherited_env = environments_by_name[env_name]
        if inherited_env.has_parent?
          merge_environments(inherited_env, inherited_environment(inherited_env.parent_name))
        else
          inherited_env
        end
      end

      def merge_environments(overriding_env, parent_env)
        Environment.new(
          overriding_env.name,
          merge_features(parent_env.features, overriding_env.features),
          overriding_env.parent_name
        )
      end

      def merge_features(parent_features, overriding_features)
        parent_features.inject([]) { |merged_features, parent_feature|
          overriding_feature = overriding_features.detect { |feature| feature.name == parent_feature.name }
          if overriding_feature
            merged_features.push(merge_feature(parent_feature, overriding_feature))
          else
            merged_features.push(parent_feature)
          end
        }
      end

      def merge_feature(parent_feature, child_feature)
        Feature.new(parent_feature.name,
          (child_feature.enabled != nil) ? child_feature.enabled : parent_feature.enabled,
          child_feature.description ? child_feature.description : parent_feature.description
        )
      end

      def environments_by_name
        parse.inject({}) { |hash, env|
          hash[env.name] = env
          hash
        }
      end

      def parse
        @parse ||= json.map { |env_name, env_info|
          parse_environment(env_name, env_info)
        }
      end

      def parse_environment(name, info)
        Environment.new(name, parse_environment_features(info), info[INHERITS_KEY])
      end

      def parse_environment_features(info)
        info.select { |key, _|
          key != INHERITS_KEY
        }.map { |feature_name, feature_info|
          parse_feature(feature_name, feature_info)
        }
      end

      def parse_feature(name, info)
        Feature.new(name, info.fetch(ENABLED_KEY), info[DESCRIPTION_KEY])
      rescue KeyError
        raise Error::InvalidFile.new(input_file)
      end

      def json
        JSON.parse(input_file)
      end

      def input_file
        File.read(input)
      rescue SystemCallError => e
        raise Error::UnreadableFile.new(e)
      end

      def valid_file?
        json
        true
      rescue JSON::ParserError
        false
      end

    end
  end
end
