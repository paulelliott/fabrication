class Fabrication::Generator::Mongoid < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

  def build_instance
    if Gem::Version.new(Mongoid::VERSION).between?(Gem::Version.new('2.3.0'), Gem::Version.new('3.9'))
      self._instance = _klass.new(_attributes, without_protection: true)
    else
      self._instance = _klass.new(_attributes)
    end
  end

  def validate_instance
    _instance.valid?
  end

end
