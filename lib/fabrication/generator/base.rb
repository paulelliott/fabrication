class Fabrication::Generator::Base

  def self.supports?(__klass); true end

  def generate(options={:save => true}, attributes=[], callbacks={})
    if callbacks[:on_init]
      self.__instance = __klass.new(*callbacks[:on_init].call)
    else
      self.__instance = __klass.new
    end

    process_attributes(attributes)

    callbacks[:after_build].each { |callback| callback.call(__instance) } if callbacks[:after_build]
    after_generation(options)
    callbacks[:after_create].each { |callback| callback.call(__instance) } if callbacks[:after_create] && options[:save]

    __instance
  end

  def initialize(klass)
    self.__klass = klass
  end

  def method_missing(method_name, *args, &block)
    if block_given?
      assign(method_name, args.first || {}, &block)
    else
      assign(method_name, {}, args.first)
    end
  end

  protected

  attr_accessor :__klass, :__instance

  def after_generation(options)
    __instance.save! if options[:save] && __instance.respond_to?(:save!)
  end

  def assign(method_name, options, raw_value=nil)
    if options.has_key?(:count)
      value = (1..options[:count]).map do |i|
        block_given? ? yield(__instance, i) : raw_value
      end
    else
      value = block_given? ? yield(__instance) : raw_value
    end
    __instance.send("#{method_name}=", value)
  end

  def post_initialize; end

  def process_attributes(attributes)
    attributes.each do |attribute|
      if Proc === attribute.value
        method_missing(attribute.name, attribute.params, &attribute.value)
      else
        method_missing(attribute.name, attribute.value)
      end
    end
  end

end
