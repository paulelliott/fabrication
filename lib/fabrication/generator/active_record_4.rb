class Fabrication::Generator::ActiveRecord4 < Fabrication::Generator::ActiveRecord

  def self.supports?(klass)
    super && active_record_4?
  end

  def build_instance
    self.__instance = __klass.new(__attributes)
  end

  private

  def self.active_record_4?
    ActiveRecord::VERSION::MAJOR == 4
  end

end
