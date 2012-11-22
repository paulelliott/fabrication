class Fabrication::Generator::ActiveRecord3 < Fabrication::Generator::ActiveRecord

  def self.supports?(klass)
    super && !active_record_4?
  end

  def build_instance
    self.__instance = __klass.new(__attributes, without_protection: true)
  end
end
