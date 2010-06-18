class Fabrication::Generator::Mongoid < Fabrication::Generator::Base

  def generate(options)
    @options = options
    @instance = super
    @instance.save
    @instance
  end

  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

end
