class Fabrication::Generator::Mongoid < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

  def build_instance
    if Gem::Version.new(Mongoid::VERSION).between?(Gem::Version.new('2.3.0'), Gem::Version.new('3.9'))
      self.__instance = __klass.new(__attributes, without_protection: true)
    else
      self.__instance = __klass.new(__attributes)
    end
  end

  def validate_instance
    __instance.valid?
  end

end
