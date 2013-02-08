class Fabrication::Generator::DataMapper < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(DataMapper) && klass.ancestors.include?(DataMapper::Hook)
  end

  def build_instance
    self.__instance = __klass.new(__attributes)
  end

  def validate_instance
    __instance.valid?
  end

  protected

  def persist
    __instance.save
  end

end
