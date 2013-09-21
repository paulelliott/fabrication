class Fabrication::UnknownFabricatorError < StandardError

  def initialize(name)
    super("No Fabricator defined for '#{name}'")
  end

end
