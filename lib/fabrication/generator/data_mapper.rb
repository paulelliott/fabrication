class Fabrication::Generator::DataMapper < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(DataMapper) && klass.ancestors.include?(DataMapper::Hook)
  end

  def build_instance
    self._instance = _klass.new(_attributes)
  end

  def validate_instance
    _instance.valid?
  end

  protected

  def persist
    _instance.save
  end

end
