class Fabrication::Fabricator

  def self.build(name, overrides={}, &block)
    schematic(name).generate({save: false}, overrides, &block)
  end

  def self.fabricate(name, overrides={}, &block)
    schematic(name).generate({save: true}, overrides, &block)
  end

  def self.to_attributes(name, overrides={}, &block)
    schematic(name).generate({save: false, attributes: true}, overrides, &block)
  end

  private

  def self.schematic(name)
    Fabrication::Support.find_definitions if Fabrication.schematics.empty?
    Fabrication.schematics[name].tap do |schematic|
      raise Fabrication::UnknownFabricatorError, "No Fabricator defined for '#{name}'" unless schematic
    end
  end

end
