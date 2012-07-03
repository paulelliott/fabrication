class Fabrication::Generator::Base

  def self.supports?(__klass); true end

  def build(attributes=[], callbacks={})
    process_attributes(attributes)

    if callbacks[:initialize_with]
      build_instance_with_constructor_override(callbacks[:initialize_with])
    elsif callbacks[:on_init]
      build_instance_with_init_callback(callbacks[:on_init])
    else
      build_instance
    end

    callbacks[:after_build].each { |callback| callback.call(__instance) } if callbacks[:after_build]

    __instance
  end

  def create(attributes=[], callbacks=[])
    build(attributes, callbacks)
    persist
    callbacks[:after_create].each { |callback| callback.call(__instance) } if callbacks[:after_create]
    __instance
  end

  def to_hash(attributes=[], callbacks=[])
    process_attributes(attributes)
    (Fabrication::Config.active_support? ? HashWithIndifferentAccess.new : {}).tap do |hash|
      __attributes.map do |name, value|
        if value && value.respond_to?(:id)
          hash["#{name}_id"] = value.id
        else
          hash[name] = value
        end
      end
    end
  end

  def build_instance_with_constructor_override(callback)
    self.__instance = instance_eval &callback
    set_attributes
  end

  def build_instance_with_init_callback(callback)
    self.__instance = __klass.new(*callback.call)
    set_attributes
  end

  def build_instance
    self.__instance = __klass.new
    set_attributes
  end

  def set_attributes
    __attributes.each do |k,v|
      __instance.send("#{k}=", v)
    end
  end

  def initialize(klass)
    self.__klass = klass
  end

  def method_missing(method_name, *args, &block)
    return __attributes[method_name] if args.empty? && !block_given? && __attributes[method_name]

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

  def persist
    __instance.save! if __instance.respond_to?(:save!)
  end

  def assign(method_name, options, value=nil, &block)
    if options.has_key?(:count)
      assign_collection(method_name, options[:count], value, &block)
    else
      assign_field(method_name, value, &block)
    end
  end

  def assign_field(field_name, value, &block)
    __attributes[field_name] = block_given? ? yield(__attributes) : value
  end

  def assign_collection(field_name, count, value, &block)
    __attributes[field_name] = block_given? ?
      (1..count).map { |i| yield(__attributes, i) } :
      value * count
  end

  def post_initialize; end

  def process_attributes(attributes)
    attributes.each do |attribute|
      __transient_fields << attribute.name if attribute.transient?
      if Proc === attribute.value
        method_missing(attribute.name, attribute.params, &attribute.value)
      else
        method_missing(attribute.name, attribute.value)
      end
    end
    __attributes.reject! { |k| __transient_fields.include?(k) }
  end

  def __transient_fields
    @__transient_fields ||= []
  end

end
