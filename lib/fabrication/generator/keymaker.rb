class Fabrication::Generator::Keymaker < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(Keymaker) && klass.ancestors.include?(Keymaker::Node)
  end

  def persist
    _instance.save
  end

  def validate_instance
    _instance.valid?
  end

end
