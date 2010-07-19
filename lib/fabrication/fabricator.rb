class Fabrication::Fabricator

  GENERATORS = [
    Fabrication::Generator::ActiveRecord,
    Fabrication::Generator::Mongoid,
    Fabrication::Generator::Base
  ]

  attr_accessor :class_name, :schematic

  def initialize(class_name, parent=nil, &block)
    self.class_name = class_name
    klass = class_for(class_name)
    self.schematic = parent ? parent.schematic.clone.merge!(&block) : Fabrication::Schematic.new(&block)
    self.generator = GENERATORS.detect do |gen|
      gen.supports?(klass)
    end.new(klass, schematic)
  end

  def fabricate(options={})
    generator.generate(options)
  end

  private

  attr_accessor :generator

  def class_for(class_or_to_s)
    if class_or_to_s.respond_to?(:to_sym)
      class_name = variable_name_to_class_name(class_or_to_s)
      class_name.split('::').inject(Object) do |object, string|
        object.const_get(string)
      end
    else
      class_or_to_s
    end
  end

  def variable_name_to_class_name(name)
    name.to_s.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
  end

end
