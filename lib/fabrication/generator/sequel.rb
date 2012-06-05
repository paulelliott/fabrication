class Fabrication::Generator::Sequel < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(Sequel) && klass.ancestors.include?(Sequel::Model)
  end

  def build_instance
    self.__instance = __klass.new(__attributes)
  end

  def persist
    __instance.save
  end

end
