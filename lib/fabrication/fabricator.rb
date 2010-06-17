class Fabrication::Fabricator

  GENERATORS = [
    Fabrication::Generator::ActiveRecord,
    Fabrication::Generator::Base
  ]

  attr_accessor :fabricator

  def initialize(class_name, &block)
    klass = class_for(class_name)
    self.fabricator = GENERATORS.detect do |generator|
      generator.supports?(klass)
    end.new(klass, &block)
  end

  def fabricate(options={})
    fabricator.generate(options)
  end

  protected

  #Stolen directly from factory_girl. Thanks thoughtbot!
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

  #Stolen directly from factory_girl. Thanks thoughtbot!
  def variable_name_to_class_name(name)
    name.to_s.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
  end

end
