module Fabrication
  autoload :DuplicateFabricatorError, 'fabrication/errors/duplicate_fabricator_error'
  autoload :UnfabricatableError,      'fabrication/errors/unfabricatable_error'
  autoload :UnknownFabricatorError,   'fabrication/errors/unknown_fabricator_error'
  autoload :MisplacedFabricateError,  'fabrication/errors/misplaced_fabricate_error'

  module Schematic
    autoload :Attribute,  'fabrication/schematic/attribute'
    autoload :Definition, 'fabrication/schematic/definition'
    autoload :Manager,    'fabrication/schematic/manager'
    autoload :Evaluator,  'fabrication/schematic/evaluator'
    autoload :Runner,     'fabrication/schematic/runner'
  end

  autoload :Config,     'fabrication/config'
  autoload :Fabricator, 'fabrication/fabricator'
  autoload :Sequencer,  'fabrication/sequencer'
  autoload :Support,    'fabrication/support'
  autoload :Transform,  'fabrication/transform'

  autoload :Cucumber, 'fabrication/cucumber/step_fabricator'

  module Generator
    autoload :ActiveRecord,  'fabrication/generator/active_record'
    autoload :ActiveRecord4, 'fabrication/generator/active_record_4'
    autoload :DataMapper,    'fabrication/generator/data_mapper'
    autoload :Mongoid,       'fabrication/generator/mongoid'
    autoload :Sequel,        'fabrication/generator/sequel'
    autoload :Base,          'fabrication/generator/base'
  end

  def self.clear_definitions
    @manager = nil
    Sequencer.sequences.clear
  end

  def self.configure(&block)
    Fabrication::Config.configure(&block)
  end

  def self.manager
    @manager ||= Fabrication::Schematic::Manager.new
  end

  def self.schematics
    puts "DEPRECATION WARNING: Fabrication.schematics has been replaced by Fabrication.manager"
    manager
  end
end

def Fabricator(name, options={}, &block)
  Fabrication.manager.register(name, options, &block)
end

def Fabricate(name, overrides={}, &block)
  Fabrication::Fabricator.fabricate(name, overrides, &block).tap do |object|
    Fabrication::Cucumber::Fabrications[name] = object if Fabrication::Config.register_with_steps?
  end
end

class Fabricate
  def self.times(count, name, overrides={}, &block)
    count.times.map { Fabricate(name, overrides, &block) }
  end

  def self.attributes_for(name, overrides={}, &block)
    Fabrication::Fabricator.to_attributes(name, overrides, &block)
  end

  def self.build(name, overrides={}, &block)
    Fabrication::Fabricator.build(name, overrides, &block).tap do |object|
      Fabrication::Cucumber::Fabrications[name] = object if Fabrication::Config.register_with_steps?
    end
  end

  def self.sequence(name=Fabrication::Sequencer::DEFAULT, start=nil, &block)
    Fabrication::Sequencer.sequence(name, start, &block)
  end
end

module FabricationMethods
  def fabrications
    Fabrication::Cucumber::Fabrications
  end
end
