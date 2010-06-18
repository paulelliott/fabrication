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
    assign(instance, method_name.to_s, block_given? ? yield : args.first)
  end

  def self.supports?(klass); true end

  private

  def assign(instance, method_name, value)
    instance.send("#{method_name.to_s}=", value)
  end

end
