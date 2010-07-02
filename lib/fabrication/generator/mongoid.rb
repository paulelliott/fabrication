class Fabrication::Generator::Mongoid < Fabrication::Generator::Base

  def after_generation
    instance.save
  end

  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

end
