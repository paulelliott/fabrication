require 'singleton'

class Fabrication::Schematic::Manager
  include Singleton

  def preinitialize
    @initializing = true
    clear
  end

  def initializing?
    @initializing ||= nil
  end

  def schematics
    @schematics ||= {}
  end

  def clear; schematics.clear end
  def empty?; schematics.empty? end

  def freeze
    @initializing = false
  end

  def register(name, options, &block)
    name = name.to_sym
    raise_if_registered(name)
    store(name, Array(options.delete(:aliases)), options, &block)
  end

  def [](name)
    schematics[name.to_sym]
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

  def raise_if_registered(name)
    (raise Fabrication::DuplicateFabricatorError, name) if self[name]
  end

  def store(name, aliases, options, &block)
    schematic = schematics[name] = Fabrication::Schematic::Definition.new(name, options, &block)
    aliases.each { |as| schematics[as.to_sym] = schematic }
  end

end
