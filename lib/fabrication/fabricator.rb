class Fabrication::Fabricator

  def self.build(name, overrides={}, &block)
    fail_if_initializing(name)
    schematic(name).build(overrides, &block)
  end

  def self.fabricate(name, overrides={}, &block)
    fail_if_initializing(name)
    schematic(name).fabricate(overrides, &block)
  end

  def self.to_attributes(name, overrides={}, &block)
    fail_if_initializing(name)
    schematic(name).to_attributes(overrides, &block)
  end

  private

  def self.fail_if_initializing(name)
    raise Fabrication::MisplacedFabricateError.new(
      "You tried to fabricate `#{name}` while Fabricators were still loading. Check your fabricator files and make sure you didn't accidentally type `Fabricate` instead of `Fabricator` in there somewhere."
    ) if Fabrication.schematics.initializing?
  end

  def self.schematic(name)
    Fabrication::Support.find_definitions if Fabrication.schematics.empty?
    Fabrication.schematics[name].tap do |schematic|
      raise Fabrication::UnknownFabricatorError, "No Fabricator defined for '#{name}'" unless schematic
    end
  end

end
