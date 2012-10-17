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
      __attributes[attribute.name] = attribute.processed_value(__attributes)
    end
    __attributes.reject! { |k| __transient_fields.include?(k) }
  end

  def __transient_fields
    @__transient_fields ||= []
  end

end
