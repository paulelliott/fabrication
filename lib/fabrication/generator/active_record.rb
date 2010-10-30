class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  def associations
    @associations ||= klass.reflections.keys
  end

  def association?(method_name)
    associations.include?(method_name.to_sym)
  end

  protected

  def after_generation(options)
    instance.save if options[:save]
  end

end
