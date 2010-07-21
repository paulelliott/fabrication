module Fabrication

  require 'fabrication/errors'

  autoload :Fabricator, 'fabrication/fabricator'
  autoload :Schematic,  'fabrication/schematic'
  autoload :Support,    'fabrication/support'

  module Generator
    autoload :ActiveRecord, 'fabrication/generator/active_record'
    autoload :Mongoid,      'fabrication/generator/mongoid'
    autoload :Base,         'fabrication/generator/base'
  end

  class << self

    def schematic(name, options, &block)
      raise DuplicateFabricatorError if fabricators.has_key?(name)
      parent = fabricators[options[:from]]
      if parent
        class_name = parent.class_name
      elsif options[:from]
        class_name = options[:from]
      else
        class_name = name
      end
      fabricators[name] = Fabricator.new(class_name, parent, &block)
    end

    def generate(name, options, &block)
      find_definitions if @@fabricators.nil?
      raise UnknownFabricatorError unless Fabrication::Support.fabricatable?(name)
      schematic(name, {}) unless fabricators.has_key?(name)
      fabricators[name].fabricate(options, &block)
    end

    def find_definitions
      fabricator_file_paths = [
        File.join('test', 'fabricators'),
        File.join('spec', 'fabricators')
      ]
      fabricator_file_paths.each do |path|
        if File.exists?("#{path}.rb")
          require("#{path}.rb") 
        end

        if File.directory? path
          Dir[File.join(path, '*.rb')].each do |file|
            require file
          end
        end
      end
    end

    def clear_definitions
      fabricators.clear
    end

    def fabricators
      @@fabricators ||= {}
    end

    private

    @@fabricators = nil

  end

end

def Fabricator(name, options={}, &block)
  Fabrication.schematic(name, options, &block)
end

def Fabricate(name, options={}, &block)
  Fabrication.generate(name, options, &block)
end
