class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  def build_instance
    self.__instance = __klass.new.tap do |obj|
      __attributes.each { |attr, val| obj.send(:"#{attr}=", val) }
    end
  end

end
