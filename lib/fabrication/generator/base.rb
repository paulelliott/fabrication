class Fabrication::Generator::Base

  def self.supports?(klass); true end

  def generate(options={:save => true}, attributes=[], callbacks={})
    process_attributes(attributes)

    callbacks[:after_build].each { |callback| callback.call(instance) } if callbacks[:after_build]
    after_generation(options)
    callbacks[:after_create].each { |callback| callback.call(instance) } if callbacks[:after_create]
    instance
  end

  def initialize(klass)
    self.instance = klass.new
  end

  def method_missing(method_name, *args, &block)
    assign(method_name, args.first, &block)
  end

  protected

  attr_accessor :instance

  def after_generation(options); end

  def assign(method_name, param)
    if param.is_a?(Hash) && param.has_key?(:count)
      value = (1..param[:count]).map do |i|
        block_given? ? yield(instance, i) : param
      end
    else
      value = block_given? ? yield(instance) : param
    end
    instance.send("#{method_name}=", value)
  end

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
