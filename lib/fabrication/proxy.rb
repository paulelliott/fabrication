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

  def method_missing(method_name, *args, &block)
    if block
      # copy the original getter
      @instance.instance_variable_set("@__#{method_name}_original", @instance.method(method_name).clone)

      # store the block for lazy generation
      @instance.instance_variable_set("@__#{method_name}_block", block)

      # redefine the getter
      @instance.instance_eval %<
        def #{method_name}
          if @__#{method_name}_original.call.nil?
            send(:#{method_name}=, @__#{method_name}_block.call)
          end
          @__#{method_name}_original.call
        end
      >
    else
      assign(@instance, method_name.to_s, args.first)
    end
  end

  private

  def assign(instance, method_name, value)
    instance.send("#{method_name.to_s}=", value)
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
