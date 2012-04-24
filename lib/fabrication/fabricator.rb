class Fabrication::Fabricator

  def self.generate(name, options={}, overrides={}, &block)
    Fabrication::Support.find_definitions if Fabrication.schematics.empty?
    schematic = Fabrication.schematics[name]
    raise Fabrication::UnknownFabricatorError, "No Fabricator defined for '#{name}'" unless schematic
    schematic.generate(options, overrides, &block)
  end

end
