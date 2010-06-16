module Fabrication

  autoload :Fabricator, 'fabrication/fabricator'

  module Generator
    autoload :ActiveRecord, 'fabrication/generator/activerecord'
    autoload :Base,         'fabrication/generator/base'
  end

  class << self

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

end

def Fabricator(name, &block)
  Fabrication.schematic(name, &block)
end

def Fabricate(name, options={})
  Fabrication.generate(name, options)
end
