module FlipTheSwitch
  class Feature < Struct.new(:name, :enabled, :description)
    def initialize(name, enabled, description = nil)
      super(name, enabled, description)
    end
  end
end
