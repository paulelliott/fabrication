class Fabrication::Generator::Base

  def self.supports?(klass); true end

  def after_create(&block)
    self.after_create_block = block if block_given?
  end

  def generate(options={:save => true}, attributes=[])
    process_attributes(attributes)
    after_generation(options)
    after_create_block.call(instance) if after_create_block
    instance
  end

  def initialize(klass)
    self.instance = klass.new
  end

  def method_missing(method_name, *args, &block)
    assign(method_name, args.first, &block)
  end

  protected

  def after_generation(options); end

  private

  attr_accessor :after_create_block, :instance

  def assign(method_name, param)
    value = nil
    if param.is_a?(Hash) && param.has_key?(:count) && param[:count] > 1
      value = (1..param[:count]).map do |i|
        block_given? ? yield(instance, i) : param
      end
    else
      value = block_given? ? yield(instance) : param
    end
    instance.send("#{method_name.to_s}=", value)
  end

  def process_attributes(attributes)
    attributes.each do |attribute|
      if attribute.name == :after_create
        after_create(&attribute.value)
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
