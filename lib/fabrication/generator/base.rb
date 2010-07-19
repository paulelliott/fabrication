class Fabrication::Generator::Base

  def self.supports?(klass); true end

  def after_create(&block)
    self.after_create_block = block if block_given?
  end

  def generate(options={})
    self.instance = parent ? parent.fabricate : klass.new
    self.options = options
    instance_eval(&block) if block
    options.each { |k,v| assign(k, v) }
    after_generation
    after_create_block.call(instance) if after_create_block
    instance
  end

  def initialize(klass, parent=nil, &block)
    self.klass = klass
    self.parent = parent
    self.block = block
  end

  def method_missing(method_name, *args, &block)
    assign(method_name.to_s, args.first, &block)
  end

  protected

  def after_generation; end

  private

  attr_accessor :after_create_block, :block, :instance, :klass, :options, :parent

  def assign(method_name, param)
    value = nil
    if param.is_a?(Hash) && param[:count] && param[:count] > 1
      value = (1..param[:count]).map do |i|
        block_given? ? yield(instance, i) : param
      end
    else
      value = block_given? ? yield(instance) : param
    end
    instance.send("#{method_name.to_s}=", value)
  end

end
