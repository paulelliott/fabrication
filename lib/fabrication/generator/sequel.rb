class Fabrication::Generator::Sequel < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(Sequel) && klass.ancestors.include?(Sequel::Model)
  end

  def set_attributes
    __instance.set_fields(__attributes, __attributes.keys)
  end

  def persist
    __instance.save
  end

end
