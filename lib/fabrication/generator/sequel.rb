class Fabrication::Generator::Sequel < Fabrication::Generator::Base

  def initialize(klass)
    super
    load_instance_hooks
  end

  def self.supports?(klass)
    defined?(Sequel) && klass.ancestors.include?(Sequel::Model)
  end

  def set_attributes
    _attributes.each do |key, value|
      if (reflection = _klass.association_reflections[key]) && value.is_a?(Array)
        _instance.associations[key] = value
        _instance.after_save_hook do
          value.each { |o| _instance.send(reflection.add_method, o) }
        end
      else
        _instance.send("#{key}=", value)
      end
    end
  end

  def persist
    _instance.save
  end

  def validate_instance
    _instance.valid?
  end

  private

  def load_instance_hooks
    klass = _klass.respond_to?(:cti_base_model) ? _klass.cti_base_model : _klass
    klass.plugin :instance_hooks unless klass.new.respond_to? :after_save_hook
  end

end
