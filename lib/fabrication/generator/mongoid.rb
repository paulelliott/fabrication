class Fabrication::Generator::Mongoid < Fabrication::Generator::Base
  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

  def build_instance
    self._instance = if _klass.respond_to?(:protected_attributes)
                       _klass.new(_attributes, without_protection: true)
                     else
                       _klass.new(_attributes)
                     end
  end
end
