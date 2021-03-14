class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base
  def self.supports?(klass)
    # Some gems will declare an ActiveRecord module for their own purposes
    # so we can't assume because we have the ActiveRecord module that we also
    # have ActiveRecord::Base. Because defined? can return nil we ensure that nil
    # becomes false.
    defined?(ActiveRecord) && defined?(ActiveRecord::Base) && klass.ancestors.include?(ActiveRecord::Base) || false
  end

  def build_instance
    self._instance = if _klass.respond_to?(:protected_attributes)
                       _klass.new(_attributes, without_protection: true)
                     else
                       _klass.new(_attributes)
                     end
  end
end
