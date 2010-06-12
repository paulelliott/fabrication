autoload :Fabricator, 'lib/fabrication/fabricator.rb'
autoload :Fabricate,  'lib/fabrication/fabricate.rb'

class Fabrication

  def self.schematic(name, &block)
    (@fabricators ||= {})[name] = Fabricator.new(name, &block)
  end

  def self.generate(name)
    @fabricators[name].fabricate
  end

end

def Fabricator(name, &block)
  Fabrication.schematic(name, &block)
end

def Fabricate(name, options={})
  Fabrication.generate(name)
end
