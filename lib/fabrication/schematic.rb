class Fabrication::Schematic

  def initialize(&block)
    instance_eval(&block)
  end

  def attribute(name)
    attributes.select { |a| a.name == name }.first
  end

  def merge!(&block)
    instance_eval(&block)
    self
  end

  def method_missing(method_name, *args, &block)
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

  class Attribute
    attr_accessor :name, :params, :value
    def initialize(name, params, value)
      self.name = name
      self.params = params
      self.value = value
    end
  end

  def attributes
    @attributes ||= []
  end

end
