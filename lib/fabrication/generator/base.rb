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

    execute_callbacks(callbacks[:after_build])

    __instance
  end

  def execute_callbacks(callbacks)
    callbacks.each { |callback| __instance.instance_eval(&callback) } if callbacks
  end

  def create(attributes=[], callbacks=[])
    build(attributes, callbacks)
    persist
    execute_callbacks(callbacks[:after_create])
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
    __attributes[method_name] || super
  end

  protected

  attr_accessor :__klass, :__instance

  def __attributes
    @__attributes ||= {}
  end

  def persist
    __instance.save! if __instance.respond_to?(:save!)
  end

  def post_initialize; end

  def process_attributes(attributes)
    attributes.each do |attribute|
      __transient_fields << attribute.name if attribute.transient?
      if Proc === attribute.value
        process_attribute(attribute.name, attribute.params, &attribute.value)
      else
        process_attribute(attribute.name, attribute.value)
      end
    end
    __attributes.reject! { |k| __transient_fields.include?(k) }
  end

  def process_attribute(method_name, *args, &block)
    if block_given?
      assign(method_name, args.first || {}, &block)
    else
      assign(method_name, {}, args.first)
    end
  end

  def assign(method_name, options, value=nil, &block)
    if options.has_key?(:count)
      assign_collection(method_name, options[:count], value, &block)
    else
      assign_field(method_name, value, &block)
    end
  end

  def assign_field(field_name, value, &block)
    __attributes[field_name] = block_given? ? block.call(__attributes) : value
  end

  def assign_collection(field_name, count, value, &block)
    __attributes[field_name] = block_given? ?
      (1..count).map { |i| block.call(__attributes, i) } :
      value * count
  end

  def __transient_fields
    @__transient_fields ||= []
  end

end
