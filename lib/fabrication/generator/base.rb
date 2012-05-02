class Fabrication::Generator::Base

  def self.supports?(__klass); true end

  def generate(options={:save => true}, attributes=[], callbacks={})
    process_attributes(attributes)

    if callbacks[:on_init]
      build_with_init_callback(callbacks[:on_init])
    else
      build
    end

    callbacks[:after_build].each { |callback| callback.call(__instance) } if callbacks[:after_build]
    after_generation(options)
    callbacks[:after_create].each { |callback| callback.call(__instance) } if callbacks[:after_create] && options[:save]

    __instance
  end

  def build_with_init_callback(callback)
    self.__instance = __klass.new(*callback.call)
    __attributes.each do |k,v|
      __instance.send("#{k}=", v)
    end
  end

  def build
    self.__instance = __klass.new
    __attributes.each do |k,v|
      __instance.send("#{k}=", v)
    end
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

  def __attributes
    @__attributes ||= {}
  end

  def after_generation(options)
    __instance.save! if options[:save] && __instance.respond_to?(:save!)
  end

  def assign(method_name, options, raw_value=nil)
    if options.has_key?(:count)
      value = (1..options[:count]).map do |i|
        block_given? ? yield(__attributes, i) : raw_value
      end
    else
      value = block_given? ? yield(__attributes) : raw_value
    end
    __attributes[method_name] = value
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
