class Fabrication::UnfabricatableError < StandardError

  def initialize(name, original_error)
    super("No class found for '#{name}' (original exception: #{original_error.message})")
  end
end
