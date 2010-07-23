class Fabrication::Schematic

  def initialize(&block)
    instance_eval(&block) if block_given?
  end

  def attribute(name)
    attributes.select { |a| a.name == name }.first
  end

  def initialize_copy(original)
    self.attributes = original.attributes.map do |a|
      Attribute.new(a.name, a.params, a.value)
    end
  end

  def merge(options, &block)
    clone.tap do |schematic|
      schematic.instance_eval(&block) if block_given?
      options.each do |name, value|
        if attribute = schematic.attribute(name)
          attribute.params = nil
          attribute.value = value
        else
          schematic.attributes << Attribute.new(name, nil, value)
        end
      end
    end
  end

  def merge!(&block)
    instance_eval(&block)
    self
  end

  def method_missing(method_name, *args, &block)
    method_name = parse_method_name(method_name, args)
    if (attr = attribute(method_name)).present?
      if block_given?
        attr.params = args.first
        attr.value = block
      else
        attr.params = nil
        attr.value = args.first
      end
    else
      if block_given?
        attributes.push(Attribute.new(method_name, args.first, block))
      else
        attributes.push(Attribute.new(method_name, nil, args.first))
      end
    end
  end

  def parse_method_name(method_name, args)
    if method_name.to_s.end_with?("!")
      method_name = method_name.to_s.chomp("!").to_sym
      args[0] ||= {}
      args[0][:force] = true
    end
    method_name
  end

  class Attribute
    attr_accessor :name, :params, :value

    def initialize(name, params, value)
      self.name = name
      self.params = params
      self.value = value
    end
  end

  attr_writer :attributes
  def attributes
    @attributes ||= []
  end

end
