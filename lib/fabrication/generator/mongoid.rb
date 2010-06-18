class Fabrication::Generator::Mongoid < Fabrication::Generator::Base

  attr_accessor :instance

  def generate(options)
    self.instance = super.tap { |t| t.save }
  end

  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

end
