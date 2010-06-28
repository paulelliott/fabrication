module Fabrication

  autoload :Fabricator, 'fabrication/fabricator'

  module Generator
    autoload :ActiveRecord, 'fabrication/generator/active_record'
    autoload :Mongoid,      'fabrication/generator/mongoid'
    autoload :Base,         'fabrication/generator/base'
  end

  class << self

    def schematic(name, options, &block)
      class_name = options[:from] || name
      fabricators[name] = Fabricator.new(class_name, &block)
    end

    def generate(name, options)
      find_definitions if fabricators.empty?
      fabricators[name].fabricate(options)
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

    private

    def fabricators
      @@fabricators ||= {}
    end

  end

end

def Fabricator(name, options={}, &block)
  Fabrication.schematic(name, options, &block)
end

def Fabricate(name, options={})
  Fabrication.generate(name, options)
end
