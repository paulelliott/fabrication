class Fabrication::Generator::Base

  attr_accessor :klass, :block, :instance

  def initialize(klass, &block)
    self.klass = klass
    self.block = block
  end

  def generate(options)
    self.instance = klass.new
    instance_eval &block
    options.each { |k,v| assign(instance, k, v) }
    instance
  end

  def method_missing(method_name, *args, &block)
    assign(instance, method_name.to_s, args.first, &block)
  end

  def self.supports?(klass); true end

  private

  def assign(instance, method_name, param)
    value = nil
    if param.is_a?(Hash) && param[:count] && param[:count] > 1
      value = (1..param[:count]).map do |i|
        block_given? ? yield(i) : param
      end
    else
      value = block_given? ? yield : param
    end
    instance.send("#{method_name.to_s}=", value)
  end

end
