class Fabrication::Schematic::Evaluator < BasicObject

  def process(definition, &block)
    @_definition = definition
    instance_eval(&block)
  end

  def method_missing(method_name, *args, &block)
    params = ::Fabrication::Support.extract_options!(args)
    value = args.first
    block = @_definition.generate_value(method_name, params) if args.empty? && !block
    @_definition.append_or_update_attribute(method_name, value, params, &block)
  end

  def after_build(&block)
    @_definition.callbacks[:after_build] ||= []
    @_definition.callbacks[:after_build] << block
  end

  def before_validation(&block)
    @_definition.callbacks[:before_validation] ||= []
    @_definition.callbacks[:before_validation] << block
  end

  def after_validation(&block)
    @_definition.callbacks[:after_validation] ||= []
    @_definition.callbacks[:after_validation] << block
  end

  def before_save(&block)
    @_definition.callbacks[:before_save] ||= []
    @_definition.callbacks[:before_save] << block
  end

  def before_create(&block)
    @_definition.callbacks[:before_create] ||= []
    @_definition.callbacks[:before_create] << block
  end

  def after_create(&block)
    @_definition.callbacks[:after_create] ||= []
    @_definition.callbacks[:after_create] << block
  end

  def after_save(&block)
    @_definition.callbacks[:after_save] ||= []
    @_definition.callbacks[:after_save] << block
  end

  def on_init(&block)
    @_definition.callbacks[:on_init] = block
  end

  def initialize_with(&block)
    @_definition.callbacks[:initialize_with] = block
  end

  def init_with(*args)
    args
  end

  def transient(*field_names)
    field_names.each do |field_name|
      @_definition.append_or_update_attribute(field_name, nil, transient: true)
    end
  end
end
