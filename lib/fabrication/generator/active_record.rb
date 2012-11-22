class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  def build_instance
    if defined?(ActiveRecord) && ActiveRecord::VERSION::MAJOR >= 4
      self.__instance = __klass.new(__attributes)
    else
      self.__instance = __klass.new(__attributes, without_protection: true)
    end
  end

end
