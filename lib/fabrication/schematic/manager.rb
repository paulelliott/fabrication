class Fabrication::Schematic::Manager

  def preinitialize
    @initializing = true
    clear
  end

  def initializing?; @initializing end

  def freeze
    @initializing = false
  end

  def clear
    schematics.clear
  end

  def empty?
    schematics.empty?
  end

  def register(name, options, &block)
    name = name.to_sym
    raise_if_registered(name)
    store(name, Array(options.delete(:aliases)), options, &block)
  end

  def [](name)
    schematics[name.to_sym]
  end

  def schematics
    @schematics ||= {}
  end

  def build_stack
    @build_stack ||= []
  end

  protected

  def raise_if_registered(name)
    if self[name]
      raise Fabrication::DuplicateFabricatorError, "'#{name}' is already defined"
    end
  end

  def store(name, aliases, options, &block)
    schematic = schematics[name] = schematic_for(name, options, &block)
    aliases.each { |as| schematics[as.to_sym] = schematic }
  end

  def resolve_class(name, parent, options)
    Fabrication::Support.class_for(
      options[:class_name] ||
        (parent && parent.klass.name) ||
        options[:from] ||
        name
    ).tap do |klass|
      raise Fabrication::UnfabricatableError, "No class found for '#{name}'" unless klass
    end
  end

  def schematic_for(name, options, &block)
    parent = self[options[:from]] if options[:from]
    klass = resolve_class(name, parent, options)

    if parent
      parent.merge(&block).tap { |s| s.klass = klass }
    else
      Fabrication::Schematic::Definition.new(klass, &block)
    end
  end
end
