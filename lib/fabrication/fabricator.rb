class Fabrication::Fabricator

  GENERATORS = [
    Fabrication::Generator::ActiveRecord,
    Fabrication::Generator::Mongoid,
    Fabrication::Generator::Base
  ]

  attr_accessor :class_name, :schematic

  def initialize(class_name, parent=nil, &block)
    self.class_name = class_name
    klass = Fabrication::Support.class_for(class_name)
    self.schematic = parent ? parent.schematic.clone.merge!(&block) : Fabrication::Schematic.new(&block)
    self.generator = GENERATORS.detect do |gen|
      gen.supports?(klass)
    end.new(klass, schematic)
  end

  def fabricate(options={}, overrides={}, &block)
    generator.generate(options, overrides, &block)
  end

  private

  attr_accessor :generator

end
