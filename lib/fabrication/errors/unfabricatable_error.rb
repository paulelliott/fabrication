class Fabrication::UnfabricatableError < StandardError

  def initialize(name)
    super("No class found for '#{name}'")
  end
end
