class Fabrication::Generator::Mongoid < Fabrication::Generator::Base

  def after_generation(options)
    instance.save if options[:save]
  end

  def self.supports?(klass)
    defined?(Mongoid) && klass.ancestors.include?(Mongoid::Document)
  end

end
