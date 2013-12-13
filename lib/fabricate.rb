class Fabricate
  def self.times(count, name, overrides={}, &block)
    count.times.map { Fabricate(name, overrides, &block) }
  end

  def self.build_times(count, name, overrides={}, &block)
    count.times.map { Fabricate.build(name, overrides, &block) }
  end

  def self.attributes_for(name, overrides={}, &block)
    Fabrication::Fabricator.to_attributes(name, overrides, &block)
  end

  def self.to_params(name, overrides={}, &block)
    Fabrication::Fabricator.to_params(name, overrides, &block)
  end

  def self.build(name, overrides={}, &block)
    Fabrication::Fabricator.build(name, overrides, &block).tap do |object|
      Fabrication::Cucumber::Fabrications[name] = object if Fabrication::Config.register_with_steps?
    end
  end

  def self.sequence(name=Fabrication::Sequencer::DEFAULT, start=nil, &block)
    Fabrication::Sequencer.sequence(name, start, &block)
  end
end
