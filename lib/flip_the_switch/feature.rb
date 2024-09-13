module FlipTheSwitch
  class Feature < Struct.new(:name, :enabled, :description, :is_real_time)
    def initialize(name, enabled, description = nil, is_real_time)
      super(name, enabled, description, is_real_time)
    end
  end
end
