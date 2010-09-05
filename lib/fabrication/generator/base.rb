class Fabrication::Generator::Base

  def self.supports?(klass); true end

  def after_build(&block)
    callbacks[:after_build] = block if block_given?
  end

  def after_create(&block)
    callbacks[:after_create] = block if block_given?
  end

  def callbacks
    @callbacks ||= {}
  end

  def generate(options={:save => true}, attributes=[])
    process_attributes(attributes)
    callbacks[:after_build].call(instance) if callbacks.include?(:after_build)
    after_generation(options)
    callbacks[:after_create].call(instance) if callbacks.include?(:after_create)
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
      case attribute.name
      when :after_create; after_create(&attribute.value)
      when :after_build; after_build(&attribute.value)
      else
        if Proc === attribute.value
          method_missing(attribute.name, attribute.params, &attribute.value)
        else
          method_missing(attribute.name, attribute.value)
        end
      end
    end
  end

end
