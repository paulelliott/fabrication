autoload :Fabricator, 'lib/fabrication/fabricator.rb'
autoload :Fabricate,  'lib/fabrication/fabricate.rb'

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

def Fabricator(name, &block)
  Fabrication.schematic(name, &block)
end

def Fabricate(name, options={})
  Fabrication.generate(name, options)
end
