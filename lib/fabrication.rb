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
      if options[:class_name]
        class_name = options[:class_name]
      elsif parent
        class_name = parent.class_name
      elsif options[:from]
        class_name = options[:from]
      else
        class_name = name
      end
      fabricators[name] = Fabricator.new(class_name, parent, &block)
    end

    def generate(name, options, overrides, &block)
      Support.find_definitions if @@fabricators.nil?
      raise UnknownFabricatorError unless Fabrication::Support.fabricatable?(name)
      schematic(name, {}) unless fabricators.has_key?(name)
      fabricators[name].fabricate(options, overrides, &block)
    end

    def sequence(name, start=0)
      idx = sequences[name] ||= start

      (block_given? ? yield(idx) : idx).tap do
        sequences[name] += 1
      end
    end

    def attributes_for(name, options)
      hash = defined?(HashWithIndifferentAccess) ? HashWithIndifferentAccess.new : {}
      fetch_schematic(name).attributes.inject(hash) do |hash, attribute|
        value = attribute.value.respond_to?(:call) ? attribute.value.call : attribute.value
        hash.merge(attribute.name => value)
      end.merge(options)
    end

    def clear_definitions
      fabricators.clear
      sequences.clear
    end

    def fabricators
      @@fabricators ||= {}
    end

    def sequences
      @@sequences ||= {}
    end

    private

    @@fabricators = nil

    def fetch_schematic(name)
      if fabricator = fabricators[name]
        fabricator.schematic
      else
        # force finding definitions after setting @@fabricators to an empty array
        Fabrication.send(:class_variable_set, :@@fabricators, nil) if Fabrication.fabricators.empty?
        build(name)
        fetch_schematic(name)
      end
    end

  end

end

def Fabricator(name, options={}, &block)
  Fabrication.schematic(name, options, &block)
end

def Fabricate(name, options={}, &block)
  Fabrication.generate(name, {:save => true}, options, &block)
end

class Fabricate

  class << self

    def build(name, options={}, &block)
      Fabrication.generate(name, {:save => false}, options, &block)
    end

    def sequence(name, start=0, &block)
      Fabrication.sequence(name, start, &block)
    end

    def attributes_for(name, options={})
      Fabrication.attributes_for(name, options)
    end

  end

end
