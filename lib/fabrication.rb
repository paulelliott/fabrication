autoload :Fabricate, 'fabricate'

if defined?(Rake)
  require 'rake'
  Dir[File.join(File.dirname(__FILE__), 'tasks', '**/*.rake')].each { |rake| load rake }
end

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
    manager.clear
    Sequencer.sequences.clear
  end

  def self.configure(&block)
    Fabrication::Config.configure(&block)
  end

  def self.manager
    @manager ||= Fabrication::Schematic::Manager.instance
  end

  def self.schematics
    puts "DEPRECATION WARNING: Fabrication.schematics has been replaced by Fabrication.manager and will be removed in 3.0.0."
    manager
  end
end

def Fabricator(name, options={}, &block)
  Fabrication.manager.register(name, options, &block)
end

def Fabricate(name, overrides={}, &block)
  Fabricate.create(name, overrides, &block).tap do |object|
    Fabrication::Cucumber::Fabrications[name] = object if Fabrication::Config.register_with_steps?
  end
end

module FabricationMethods
  def fabrications
    Fabrication::Cucumber::Fabrications
  end
end
