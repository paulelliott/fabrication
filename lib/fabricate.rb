class Fabricate
  def self.times(count, name, overrides={}, &block)
    count.times.map { Fabricate(name, overrides, &block) }
  end

  def self.build_times(count, name, overrides={}, &block)
    count.times.map { Fabricate.build(name, overrides, &block) }
  end

  def self.attributes_for_times(count, name, overrides={}, &block)
    count.times.map { Fabricate.attributes_for(name, overrides, &block) }
  end

  def self.attributes_for(name, overrides={}, &block)
    schematic(name).to_attributes(overrides, &block)
  end

  def self.to_params(name, overrides={}, &block)
    schematic(name).to_params(overrides, &block)
  end

  def self.build(name, overrides={}, &block)
    schematic(name).build(overrides, &block).tap do |object|
      Fabrication::Cucumber::Fabrications[name] = object if Fabrication::Config.register_with_steps?
    end
  end

  def self.create(name, overrides={}, &block)
    schematic(name).fabricate(overrides, &block)
  end

  def self.sequence(name=Fabrication::Sequencer::DEFAULT, start=nil, &block)
    Fabrication::Sequencer.sequence(name, start, &block)
  end

  def self.schematic(name)
    raise Fabrication::MisplacedFabricateError.new(name) if Fabrication.manager.initializing?
    Fabrication.manager.load_definitions if Fabrication.manager.empty?
    Fabrication.manager[name] || raise(Fabrication::UnknownFabricatorError.new(name))
  end
end
