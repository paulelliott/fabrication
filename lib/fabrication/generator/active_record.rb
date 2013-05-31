class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  private

  def validate_instance
    _instance.valid?
  end

  def build_instance
    self._instance = _klass.new(_attributes, without_protection: true)
  end

end
