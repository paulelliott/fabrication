class Fabrication::Generator::Mongoid < Fabrication::Generator::Base
  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

  def assign(method_name, options, raw_value=nil)
    if options.has_key?(:count)
      value = (1..options[:count]).map do |i|
        block_given? ? yield(__instance, i) : raw_value
      end
    else
      value = block_given? ? yield(__instance) : raw_value
    end

    if Mongoid.allow_dynamic_fields && !__instance.respond_to?("#{method_name}=")
      __instance[method_name] = value
    else
      __instance.send("#{method_name}=", value)
    end
  end
end
