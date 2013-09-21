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
    raise Fabrication::MisplacedFabricateError.new(name) if Fabrication.manager.initializing?
  end

  def self.schematic(name)
    Fabrication::Support.find_definitions if Fabrication.manager.empty?
    Fabrication.manager[name].tap do |schematic|
      raise Fabrication::UnknownFabricatorError.new(name) unless schematic
    end
  end

end
