module Fabrication

  autoload :DuplicateFabricatorError, 'fabrication/errors'
  autoload :UnfabricatableError,      'fabrication/errors'

  autoload :Fabricator, 'fabrication/fabricator'
  autoload :Sequencer,  'fabrication/sequencer'
  autoload :Schematic,  'fabrication/schematic'
  autoload :Support,    'fabrication/support'

  module Generator
    autoload :ActiveRecord, 'fabrication/generator/active_record'
    autoload :Mongoid,      'fabrication/generator/mongoid'
    autoload :Base,         'fabrication/generator/base'
  end

  def self.clear_definitions
    Fabricator.schematics.clear
    Sequencer.sequences.clear
  end

end

def Fabricator(name, options={}, &block)
  Fabrication::Fabricator.define(name, options, &block)
end

def Fabricate(name, overrides={}, &block)
  Fabrication::Fabricator.generate(name, {
    :save => true
  }, overrides, &block)
end

class Fabricate

  class << self

    def build(name, options={}, &block)
      Fabrication::Fabricator.generate(name, {
        :save => false
      }, options, &block)
    end

    def sequence(name, start=0, &block)
      Fabrication::Sequencer.sequence(name, start, &block)
    end

    def attributes_for(name, options={}, &block)
      Fabrication::Fabricator.generate(name, {
        :save => false, :attributes => true
      }, options, &block)
    end

  end

end
