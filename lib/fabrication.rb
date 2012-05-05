module Fabrication

  autoload :DuplicateFabricatorError, 'fabrication/errors/duplicate_fabricator_error'
  autoload :UnfabricatableError,      'fabrication/errors/unfabricatable_error'
  autoload :UnknownFabricatorError,   'fabrication/errors/unknown_fabricator_error'
  autoload :MisplacedFabricateError,   'fabrication/errors/misplaced_fabricate_error'

  module Schematic
    autoload :Attribute,  'fabrication/schematic/attribute'
    autoload :Definition, 'fabrication/schematic/definition'
    autoload :Manager,    'fabrication/schematic/manager'
  end

  autoload :Config,     'fabrication/config'
  autoload :Fabricator, 'fabrication/fabricator'
  autoload :Sequencer,  'fabrication/sequencer'
  autoload :Support,    'fabrication/support'
  autoload :Transform,  'fabrication/transform'

  module Cucumber
    autoload :StepFabricator, 'fabrication/cucumber/step_fabricator'
  end

  module Generator
    autoload :ActiveRecord, 'fabrication/generator/active_record'
    autoload :DataMapper,   'fabrication/generator/data_mapper'
    autoload :Mongoid,      'fabrication/generator/mongoid'
    autoload :Sequel,       'fabrication/generator/sequel'
    autoload :Base,         'fabrication/generator/base'
  end

  def self.clear_definitions
    @schematics = nil
    Sequencer.sequences.clear
  end

  def self.configure(&block)
    Fabrication::Config.configure(&block)
  end

  def self.initializing=(value)
    @initializing = value
  end

  def self.initializing?
    @initializing
  end

  def self.schematics
    @schematics ||= Fabrication::Schematic::Manager.new
  end

end

def Fabricator(name, options={}, &block)
  Fabrication.schematics.register(name, options, &block)
end

def Fabricate(name, overrides={}, &block)
  raise Fabrication::MisplacedFabricateError.new(name) if Fabrication.initializing?
  Fabrication::Fabricator.generate(name, {
    :save => true
  }, overrides, &block)
end

class Fabricate

  def self.attributes_for(name, options={}, &block)
    Fabrication::Fabricator.generate(name, {
      :save => false, :attributes => true
    }, options, &block)
  end

  def self.build(name, options={}, &block)
    Fabrication::Fabricator.generate(name, {
      :save => false
    }, options, &block)
  end

  def self.sequence(name=Fabrication::Sequencer::DEFAULT, start=0, &block)
    Fabrication::Sequencer.sequence(name, start, &block)
  end

end

module FabricationMethods
  def fabrications
    Fabrication::Cucumber::Fabrications
  end
end
