class Fabrication::Generator::Mongoid < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

  def build_instance
    if Gem::Version.new(Mongoid::VERSION) >= Gem::Version.new('2.3.0')
      self.__instance = __klass.new(__attributes, without_protection: true)
    else
      self.__instance = __klass.new(__attributes)
    end
  end

end
