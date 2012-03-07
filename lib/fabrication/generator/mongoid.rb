class Fabrication::Generator::Mongoid < Fabrication::Generator::Base
  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

  def assign(method_name, options, raw_value=nil)
    if options.has_key?(:count)
      value = (1..options[:count]).map do |i|
        block_given? ? yield(instance, i) : raw_value
      end
    else
      value = block_given? ? yield(instance) : raw_value
    end

    if Mongoid.allow_dynamic_fields && !instance.respond_to?("#{method_name}=")
      instance[method_name] = value
    else
      instance.send("#{method_name}=", value)
    end
  end
end
