class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  def build_instance
    if self.class.without_protection?
      self._instance = _klass.new(_attributes, without_protection: true)
    else
      self._instance = _klass.new(_attributes)
    end
  end

  protected

  def self.without_protection?
    @without_protection = Gem::Version.new(ActiveRecord::VERSION::STRING).between?(Gem::Version.new('3.1.0'), Gem::Version.new('3.9')) if @without_protection.nil?
    @without_protection
  end

  def validate_instance
    _instance.valid?
  end

end
