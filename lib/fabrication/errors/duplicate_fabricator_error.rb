class Fabrication::DuplicateFabricatorError < StandardError
  def initialize(string)
    super("'#{string}' is already defined")
  end
end
