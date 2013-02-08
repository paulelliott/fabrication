class Fabrication::Generator::Keymaker < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(Keymaker) && klass.ancestors.include?(Keymaker::Node)
  end

  def persist
    __instance.save
  end

  def validate_instance
    __instance.valid?
  end

end
