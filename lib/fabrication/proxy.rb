class Fabrication::Proxy

  def initialize(class_name, &block)
    @class_name = class_for(class_name)
    @block = block
  end

  def create(options)
    @instance = @class_name.new
    instance_eval &@block
    options.each { |k,v| assign(@instance, k, v) }
    @instance
  end

  def method_missing(method, *args, &block)
    args = [block.call] if block
    assign(@instance, method, args.first)
  end

  private

  def assign(instance, attribute, *value, &block)
    instance.send("#{attribute.to_s}=", value.first)
  end

  #Stolen directly from factory_girl. Thanks thoughtbot!
  def class_for(class_or_to_s)
    if class_or_to_s.respond_to?(:to_sym)
      class_name = variable_name_to_class_name(class_or_to_s)
      class_name.split('::').inject(Object) do |object, string|
        object.const_get(string)
      end
    else
      class_or_to_s
    end
  end

  #Stolen directly from factory_girl. Thanks thoughtbot!
  def variable_name_to_class_name(name)
    name.to_s.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
  end

end
