class Fabrication::Fabricator

  def self.build(name, overrides={}, &block)
    schematic(name).build(overrides, &block)
  end

  def self.fabricate(name, overrides={}, &block)
    schematic(name).fabricate(overrides, &block)
  end

  def self.to_attributes(name, overrides={}, &block)
    schematic(name).to_attributes(overrides, &block)
  end

  private

  def self.schematic(name)
    Fabrication::Support.find_definitions if Fabrication.schematics.empty?
    Fabrication.schematics[name].tap do |schematic|
      raise Fabrication::UnknownFabricatorError, "No Fabricator defined for '#{name}'" unless schematic
    end
  end

end
