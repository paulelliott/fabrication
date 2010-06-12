class Fabricator

  def initialize(name, &block)
    @class = class_for(name)
    @block = block
  end

  def fabricate
    @instance = @class.new
    instance_eval &@block
    @instance
  end

  def method_missing(method, *args)
    @instance.send("#{method}=", args.first)
  end

  private

  #Stolen directly from factory_girl. Thanks ThoughtBot!
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
