class Fabrication::Fabricator

  class << self

    def define(name, options={}, &block)
      raise Fabrication::DuplicateFabricatorError if schematics.include?(name)
      schematics[name] = schematic_for(name, options, &block)
    end

    def generate(name, options={}, overrides={}, &block)
      Fabrication::Support.find_definitions if schematics.empty?
      (schematics[name] || define(name)).generate(options, overrides, &block)
    end

    def schematics
      @@schematics ||= {}
    end

    private

    def class_name_for(name, parent, options)
      if options[:class_name]
        class_name = options[:class_name]
      elsif parent
        class_name = parent.klass.name
      elsif options[:from]
        class_name = options[:from]
      else
        class_name = name
      end
      class_name
    end

    def schematic_for(name, options, &block)
      parent = schematics[options[:from]]
      class_name = class_name_for(name, parent, options)
      klass = Fabrication::Support.class_for(class_name)
      raise Fabrication::UnfabricatableError unless klass
      if parent
        parent.merge(&block).tap { |s| s.klass = klass }
      else
        Fabrication::Schematic.new(klass, &block)
      end
    end

  end

end
