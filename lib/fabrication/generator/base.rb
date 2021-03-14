class Fabrication::Generator::Base
  def self.supports?(_klass)
    true
  end

  def build(attributes = [], callbacks = {})
    process_attributes(attributes)

    if callbacks[:initialize_with]
      build_instance_with_constructor_override(callbacks[:initialize_with])
    elsif callbacks[:on_init]
      build_instance_with_init_callback(callbacks[:on_init])
    else
      build_instance
    end
    execute_callbacks(callbacks[:after_build])
    _instance
  end

  def create(attributes = [], callbacks = [])
    build(attributes, callbacks)
    execute_callbacks(callbacks[:before_validation])
    execute_callbacks(callbacks[:after_validation])
    execute_callbacks(callbacks[:before_save])
    execute_callbacks(callbacks[:before_create])
    persist
    execute_callbacks(callbacks[:after_create])
    execute_callbacks(callbacks[:after_save])
    _instance
  end

  def execute_callbacks(callbacks)
    callbacks&.each { |callback| _instance.instance_exec(_instance, _transient_attributes, &callback) }
  end

  def to_params(attributes = [])
    process_attributes(attributes)
    _attributes.respond_to?(:with_indifferent_access) ? _attributes.with_indifferent_access : _attributes
  end

  def to_hash(attributes = [], _callbacks = [])
    process_attributes(attributes)
    Fabrication::Support.hash_class.new.tap do |hash|
      _attributes.map do |name, value|
        if value.respond_to?(:id)
          hash["#{name}_id"] = value.id
        else
          hash[name] = value
        end
      end
    end
  end

  def build_instance_with_constructor_override(callback)
    self._instance = instance_eval(&callback)
    set_attributes
  end

  def build_instance_with_init_callback(callback)
    self._instance = _klass.new(*callback.call)
    set_attributes
  end

  def build_instance
    self._instance = _klass.new
    set_attributes
  end

  def set_attributes
    _attributes.each do |k, v|
      _instance.send("#{k}=", v)
    end
  end

  def initialize(klass)
    self._klass = klass
  end

  def method_missing(method_name, *args, &block)
    _attributes.fetch(method_name) { super }
  end

  protected

  attr_accessor :_klass, :_instance, :_transient_attributes

  def _attributes
    @_attributes ||= {}
  end

  def persist
    _instance.save! if _instance.respond_to?(:save!)
  end

  def process_attributes(attributes)
    self._transient_attributes = ({})
    attributes.each do |attribute|
      _attributes[attribute.name] = attribute.processed_value(_attributes)
      _transient_attributes[attribute.name] = _attributes[attribute.name] if attribute.transient?
    end
    _attributes.reject! { |k| _transient_attributes.keys.include?(k) }
  end
end
