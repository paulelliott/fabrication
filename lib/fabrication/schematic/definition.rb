class Fabrication::Schematic::Definition

  GENERATORS = [
    Fabrication::Generator::ActiveRecord,
    Fabrication::Generator::DataMapper,
    Fabrication::Generator::Sequel,
    Fabrication::Generator::Mongoid,
    Fabrication::Generator::Base
  ]

  attr_accessor :klass
  def initialize(klass, &block)
    self.klass = klass
    instance_eval(&block) if block_given?
  end

  def after_build(&block)
    callbacks[:after_build] ||= []
    callbacks[:after_build] << block
  end

  def after_create(&block)
    callbacks[:after_create] ||= []
    callbacks[:after_create] << block
  end

  def attribute(name)
    attributes.select { |a| a.name == name }.first
  end

  def append_or_update_attribute(attribute)
    if index = attributes.index { |a| a.name == attribute.name }
      attribute.transient! if attributes[index].transient?
      attributes[index] = attribute
    else
      attributes << attribute
    end
  end

  attr_writer :attributes
  def attributes
    @attributes ||= []
  end

  attr_writer :callbacks
  def callbacks
    @callbacks ||= {}
  end

  def generator
    @generator ||= GENERATORS.detect { |gen| gen.supports?(klass) }
  end

  def build(overrides={}, &block)
    merge(overrides, &block).instance_eval do
      generator.new(klass).build(attributes, callbacks)
    end
  end

  def fabricate(overrides={}, &block)
    merge(overrides, &block).instance_eval do
      generator.new(klass).create(attributes, callbacks)
    end
  end

  def to_attributes(overrides={}, &block)
    merge(overrides, &block).instance_eval do
      generator.new(klass).to_hash(attributes, callbacks)
    end
  end

  def initialize_copy(original)
    self.callbacks = {}
    original.callbacks.each do |type, callbacks|
      self.callbacks[type] = callbacks.clone
    end

    self.attributes = original.attributes.clone
  end

  def init_with(*args)
    args
  end

  def merge(overrides={}, &block)
    clone.tap do |schematic|
      schematic.instance_eval(&block) if block_given?
      overrides.each do |name, value|
        schematic.append_or_update_attribute(Fabrication::Schematic::Attribute.new(name.to_sym, value))
      end
    end
  end

  def method_missing(method_name, *args, &block)
    method_name = parse_method_name(method_name)
    params = args.extract_options!
    value = args.first
    block = generate_value(method_name, params) if args.empty? && !block_given?
    append_or_update_attribute(Fabrication::Schematic::Attribute.new(method_name, value, params, &block))
  end

  def on_init(&block)
    callbacks[:on_init] = block
  end

  def parse_method_name(method_name)
    if method_name.to_s.end_with?("!")
      warn("DEPRECATION WARNING: Using the \"!\" in Fabricators is no longer supported. Please remove all occurrances")
      method_name = method_name.to_s.chomp("!").to_sym
    end
    method_name
  end

  def transient(*field_names)
    field_names.each do |field_name|
      append_or_update_attribute(Fabrication::Schematic::Attribute.new(field_name, nil, transient: true))
    end
  end

  def sequence(name=Fabrication::Sequencer::DEFAULT, start=0, &block)
    name = "#{self.klass.to_s.downcase.gsub(/::/, '_')}_#{name}"
    Fabrication::Sequencer.sequence(name, start, &block)
  end

  private

  def generate_value(name, params)
    name = name.to_s
    name = name.singularize if name.respond_to?(:singularize)
    params[:count] ||= 1 if !params[:count] && name != name.to_s
    Proc.new { Fabricate(params[:fabricator] || name.to_sym) }
  end
end
