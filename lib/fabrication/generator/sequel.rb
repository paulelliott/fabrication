class Fabrication::Generator::Sequel < Fabrication::Generator::Base

  def initialize(klass)
    super
    load_instance_hooks
  end

  def self.supports?(klass)
    defined?(Sequel) && klass.ancestors.include?(Sequel::Model)
  end

  def set_attributes
    __attributes.each do |key, value|
      if (reflection = __klass.association_reflections[key]) && value.is_a?(Array)
        __instance.associations[key] = value
        __instance.after_save_hook do
          value.each { |o| __instance.send(reflection.add_method, o) }
        end
      else
        __instance.send("#{key}=", value)
      end
    end
  end

  def persist
    __instance.save
  end

  def validate_instance
    __instance.valid?
  end

  private

  def load_instance_hooks
    klass = __klass.respond_to?(:cti_base_model) ? __klass.cti_base_model : __klass
    klass.plugin :instance_hooks unless klass.new.respond_to? :after_save_hook
  end

end
