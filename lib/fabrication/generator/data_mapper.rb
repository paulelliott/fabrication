class Fabrication::Generator::DataMapper < Fabrication::Generator::Base

  class << self
    def supports?(klass)
      defined?(DataMapper) && klass.ancestors.include?(DataMapper::Hook)
    end
  end

  protected

  def after_generation(options)
    __instance.save if options[:save] && __instance.respond_to?(:save)
  end
end
