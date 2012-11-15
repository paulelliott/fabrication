class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  private
  def self.active_record_4?
    ActiveRecord::VERSION::MAJOR == 4
  end
end
