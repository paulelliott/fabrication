class Fabrication::MisplacedFabricateError < StandardError
  def initialize(name)
    super("You tried to fabricate `#{name}` while Fabricators were still loading. Check your fabricator files and make sure you didn't accidentally type `Fabricate` instead of `Fabricator` in there somewhere.")
  end
end
