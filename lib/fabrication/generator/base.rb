class Fabrication::Generator::Base

  def initialize(klass, &block)
    @klass = klass
    @block = block
  end

  def generate(options)
    @instance = @klass.new
    instance_eval &@block
    options.each { |k,v| assign(@instance, k, v) }
    @instance
  end

  def method_missing(method_name, *args, &block)
    assign(@instance, method_name.to_s, block_given? ? yield : args.first)
  end

  def self.supports?(klass); true end

  private

  def assign(instance, method_name, value)
    instance.send("#{method_name.to_s}=", value)
  end

end
