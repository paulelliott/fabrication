class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  def associations
    @associations ||= klass.reflections.keys
  end

  def method_missing(method_name, *args, &block)
    method_name = method_name.to_s
    if block_given?
      options = args.first || {}
      if !options[:force] && associations.include?(method_name.to_sym)
        count = options[:count] || 0

        # copy the original getter
        instance.instance_variable_set("@__#{method_name}_original", instance.method(method_name).clone)

        # store the block for lazy generation
        instance.instance_variable_set("@__#{method_name}_block", block)

        # redefine the getter
        instance.instance_eval %<
          def #{method_name}
            original_value = @__#{method_name}_original.call
            if @__#{method_name}_block
              if #{count} \>= 1
                original_value = #{method_name}= (1..#{count}).map { |i| @__#{method_name}_block.call(self, i) }
              else
                original_value = #{method_name}= @__#{method_name}_block.call(self)
              end
              @__#{method_name}_block = nil
            end
            original_value
          end
        >
      else
        assign(method_name, options, &block)
      end
    else
      assign(method_name, args.first)
    end
  end

  protected

  def after_generation(options)
    instance.save if options[:save]
  end

end
