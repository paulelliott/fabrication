module Fabrication

  extend self

  def schematic(name, &block)
    fabricators[name] = Fabricator.new(name, &block)
  end

  def generate(name, options)
    fabricators[name].fabricate(options)
  end

  private

  def fabricators
    @@fabricators ||= {}
  end

end

Fabrication.autoload :Fabricator, 'lib/fabrication/fabricator.rb'
Fabrication.autoload :Fabricate,  'lib/fabrication/fabricate.rb'
Fabrication.autoload :Proxy,      'lib/fabrication/proxy.rb'

def Fabricator(name, &block)
  Fabrication.schematic(name, &block)
end

def Fabricate(name, options={})
  Fabrication.generate(name, options)
end
