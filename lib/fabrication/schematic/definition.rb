class Fabrication::Schematic::Definition

  GENERATORS = [
    Fabrication::Generator::ActiveRecord,
    Fabrication::Generator::DataMapper,
    Fabrication::Generator::Sequel,
    Fabrication::Generator::Mongoid,
    Fabrication::Generator::Base
  ]

  attr_accessor :name, :options, :block
  def initialize(name, options={}, &block)
    self.name = name
    self.options = options
    self.block = block
  end

  def process_block(&block)
    Fabrication::Schematic::Evaluator.new.process(self, &block) if block_given?
  end

  def attribute(name)
    attributes.detect { |a| a.name == name }
  end

  def append_or_update_attribute(attribute_name, value, params={}, &block)
    attribute = Fabrication::Schematic::Attribute.new(klass, attribute_name, value, params, &block)
    if index = attributes.index { |a| a.name == attribute.name }
      attribute.transient! if attributes[index].transient?
      attributes[index] = attribute
    else
      attributes << attribute
    end
  end

  attr_writer :attributes
  def attributes
    load_body
    @attributes ||= []
  end

  attr_writer :callbacks
  def callbacks
    load_body
    @callbacks ||= {}
  end

  def generator
    @generator ||= Fabrication::Config.generator_for(GENERATORS, klass)
  end

  def sorted_attributes
    attributes.select(&:value_static?) + attributes.select(&:value_proc?)
  end

  def build(overrides={}, &block)
    Fabrication.manager.prevent_recursion!
    if Fabrication.manager.to_params_stack.any?
      to_params(overrides, &block)
    else
      begin
        Fabrication.manager.build_stack << name
        merge(overrides, &block).instance_eval do
          generator.new(klass).build(sorted_attributes, callbacks)
        end
      ensure
        Fabrication.manager.build_stack.pop
      end
    end
  end

  def fabricate(overrides={}, &block)
    Fabrication.manager.prevent_recursion!
    if Fabrication.manager.build_stack.any?
      build(overrides, &block)
    elsif Fabrication.manager.to_params_stack.any?
      to_params(overrides, &block)
    else
      begin
        Fabrication.manager.create_stack << name
        merge(overrides, &block).instance_eval do
          generator.new(klass).create(sorted_attributes, callbacks)
        end
      ensure
        Fabrication.manager.create_stack.pop
      end
    end
  end

  def to_params(overrides={}, &block)
    Fabrication.manager.prevent_recursion!
    Fabrication.manager.to_params_stack << name
    merge(overrides, &block).instance_eval do
      generator.new(klass).to_params(sorted_attributes)
    end
  ensure
    Fabrication.manager.to_params_stack.pop
  end

  def to_attributes(overrides={}, &block)
    merge(overrides, &block).instance_eval do
      generator.new(klass).to_hash(sorted_attributes, callbacks)
    end
  end

  def initialize_copy(original)
    self.callbacks = {}
    original.callbacks.each do |type, callbacks|
      self.callbacks[type] = callbacks.clone
    end

    self.attributes = original.attributes.clone
  end

  def generate_value(name, params)
    if params[:count] || params[:rand]
      name = Fabrication::Support.singularize(name.to_s)
      proc { Fabricate.build(params[:fabricator] || name) }
    else
      proc { Fabricate(params[:fabricator] || name) }
    end
  end

  def merge(overrides={}, &block)
    clone.tap do |definition|
      definition.process_block(&block)
      overrides.each do |name, value|
        definition.append_or_update_attribute(name.to_sym, value)
      end
    end
  end

  def klass
    @klass ||= Fabrication::Support.class_for(
      options[:class_name] ||
        (parent && parent.klass) ||
        options[:from] ||
        name
    )
  end

  protected

  def loaded?
    !!(@loaded ||= nil)
  end

  def load_body
    return if loaded?
    @loaded = true

    if parent
      merge_result = parent.merge(&block)
      @attributes = merge_result.attributes
      @callbacks = merge_result.callbacks
    else
      process_block(&block)
    end
  end

  def parent
    @parent ||= Fabrication.manager[options[:from].to_s] if options[:from]
  end
end
