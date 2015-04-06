require 'singleton'

class Fabrication::Schematic::Manager
  include Singleton

  def preinitialize
    @initializing = true
    clear
  end

  def initializing?; @initializing end

  def schematics
    @schematics ||= {}
  end

  def clear
    schematics.clear
    schematic_params.clear
  end

  def empty?
    schematics.empty? && schematic_params.empty?
  end

  def freeze
    @initializing = false
  end

  def register(name, options, &block)
    name = name.to_sym
    raise_if_registered(name)
    store(name, Array(options.delete(:aliases)), options, &block)
  end

  def [](name)
    name = name.to_sym
    schematics.fetch(name) { schematic_from_params(name) }
  end

  def build_stack
    @build_stack ||= []
  end

  def to_params_stack
    @to_params_stack ||= []
  end

  def load_definitions
    preinitialize
    Fabrication::Config.path_prefixes.each do |prefix|
      Fabrication::Config.fabricator_paths.each do |folder|
        Dir.glob(File.join(prefix, folder, '**', '*.rb')).sort.each do |file|
          load file
        end
      end
    end
  rescue Exception => e
    raise e
  ensure
    freeze
  end

  protected

  def schematic_params
    @schematic_params ||= {}
  end

  def raise_if_registered(name)
    (raise Fabrication::DuplicateFabricatorError, name) if self[name]
  end

  def store(name, aliases, options, &block)
    [name, *aliases].each { |as| schematic_params[as.to_sym] = [name, options, block] }
  end

  def resolve_class(name, parent, options)
    Fabrication::Support.class_for(
      options[:class_name] ||
        (parent && parent.klass) ||
        options[:from] ||
        name
    )
  end

  def schematic_for(name, options, &block)
    parent = self[options[:from].to_s] if options[:from]
    klass = resolve_class(name, parent, options)

    if parent
      parent.merge(&block).tap { |s| s.klass = klass }
    else
      Fabrication::Schematic::Definition.new(klass, &block)
    end
  end

  def schematic_from_params(name)
    return nil unless schematic_params.key?(name)

    schematic_name, options, block = schematic_params.delete(name)

    # resolve the main schematic if this is an alias
    if name == schematic_name
      schematic = schematic_for(schematic_name, options, &block)
    else
      schematic = self[schematic_name] unless name == schematic_name
    end

    schematics[name] = schematic
  end
end
