class Fabrication::Schematic

  GENERATORS = [
    Fabrication::Generator::ActiveRecord,
    Fabrication::Generator::Mongoid,
    Fabrication::Generator::Base
  ]

  attr_accessor :generator, :klass
  def initialize(klass, &block)
    self.klass = klass
    self.generator = GENERATORS.detect { |gen| gen.supports?(klass) }
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

  attr_writer :attributes
  def attributes
    @attributes ||= []
  end

  attr_writer :callbacks
  def callbacks
    @callbacks ||= {}
  end

  def generate(options={}, overrides={}, &block)
    attributes = merge(overrides, &block).attributes
    if options[:attributes]
      to_hash(attributes, overrides)
    else
      generator.new(klass).generate(options, attributes, callbacks)
    end
  end

  def initialize_copy(original)
    self.attributes = original.attributes.map do |a|
      Fabrication::Attribute.new(a.name, a.params, a.value)
    end
  end

  def merge(overrides={}, &block)
    clone.tap do |schematic|
      schematic.instance_eval(&block) if block_given?
      overrides.each do |name, value|
        if attribute = schematic.attribute(name)
          attribute.update!(:params => nil, :value => value)
        else
          schematic.attributes << Fabrication::Attribute.new(name, nil, value)
        end
      end
    end
  end

  def method_missing(method_name, *args, &block)
    method_name = parse_method_name(method_name, args)
    if args.empty? or args.first.is_a?(Hash)
      params = args.first || {}
      value = block_given? ? block : generate_value(method_name, params)
    else
      params = {}
      value = args.first
    end

    if attr = attribute(method_name)
      attr.update!(:params => params, :value => value)
    else
      attributes.push(Fabrication::Attribute.new(method_name, params, value))
    end
  end

  def parse_method_name(method_name, args)
    if method_name.to_s.end_with?("!")
      method_name = method_name.to_s.chomp("!").to_sym
      args[0] ||= {}
      args[0][:force] = true
    end
    method_name
  end

  private

  def generate_value(name, params)
    name = name.to_s
    name = name.singularize if name.respond_to?(:singularize)
    params[:count] ||= 1 if !params[:count] && name != name.to_s
    Proc.new { Fabricate(name.to_sym) }
  end

  def to_hash(attrs, overrides)
    hash = defined?(HashWithIndifferentAccess) ? HashWithIndifferentAccess.new : {}
    attributes.inject(hash) do |hash, attribute|
      value = attribute.value.respond_to?(:call) ? attribute.value.call : attribute.value
      hash.merge(attribute.name => value)
    end.merge(overrides)
  end

end
