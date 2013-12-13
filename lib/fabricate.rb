class Fabricate
  def self.times(count, name, overrides={}, &block)
    count.times.map { Fabricate(name, overrides, &block) }
  end

  def self.build_times(count, name, overrides={}, &block)
    count.times.map { Fabricate.build(name, overrides, &block) }
  end

  def self.attributes_for(name, overrides={}, &block)
    fail_if_initializing(name)
    schematic(name).to_attributes(overrides, &block)
  end

  def self.to_params(name, overrides={}, &block)
    fail_if_initializing(name)
    schematic(name).to_params(overrides, &block)
  end

  def self.build(name, overrides={}, &block)
    fail_if_initializing(name)
    schematic(name).build(overrides, &block).tap do |object|
      Fabrication::Cucumber::Fabrications[name] = object if Fabrication::Config.register_with_steps?
    end
  end

  def self.create(name, overrides={}, &block)
    fail_if_initializing(name)
    schematic(name).fabricate(overrides, &block)
  end

  def self.sequence(name=Fabrication::Sequencer::DEFAULT, start=nil, &block)
    Fabrication::Sequencer.sequence(name, start, &block)
  end

  def self.schematic(name)
    Fabrication::Support.find_definitions if Fabrication.manager.empty?
    Fabrication.manager[name] || raise(Fabrication::UnknownFabricatorError.new(name))
  end

  private

  def self.fail_if_initializing(name)
    raise Fabrication::MisplacedFabricateError.new(name) if Fabrication.manager.initializing?
  end

end
