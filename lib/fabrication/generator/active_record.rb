class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  attr_accessor :instance, :options

  def generate(options)
    self.options = options
    self.instance = super.tap { |t| t.save }
  end

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  def method_missing(method_name, *args, &block)
    method_name = method_name.to_s
    unless options.include?(method_name.to_sym)
      if block_given?
        unless (args.first && args.first[:force]) || instance.class.columns.map(&:name).include?(method_name)
          # copy the original getter
          instance.instance_variable_set("@__#{method_name}_original", instance.method(method_name).clone)

          # store the block for lazy generation
          instance.instance_variable_set("@__#{method_name}_block", block)

          # redefine the getter
          instance.instance_eval %<
            def #{method_name}
              original_value = @__#{method_name}_original.call
              if @__#{method_name}_block.present?
                original_value = #{method_name}= @__#{method_name}_block.call(self)
                @__#{method_name}_block = nil
                @__#{method_name}_original.call
              end
              original_value
            end
          >
        else
          assign(instance, method_name, yield)
        end
      else
        assign(instance, method_name, args.first)
      end
    end
  end

end
