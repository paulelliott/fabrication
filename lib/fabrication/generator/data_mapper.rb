class Fabrication::Generator::DataMapper < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(DataMapper) && klass.ancestors.include?(DataMapper::Hook)
  end

  protected

  def persist
    __instance.save
  end
end
