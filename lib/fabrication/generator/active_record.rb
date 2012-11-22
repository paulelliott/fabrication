class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  private

  def validate_instance
    __instance.valid?
  end

  def build_instance
    self.__instance = __klass.new(__attributes, without_protection: true)
  end

end
