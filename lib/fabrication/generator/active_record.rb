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
    count = (args && args.first && args.first[:count]) || 1
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
                if #{count} \> 1
                  original_value = #{method_name}= (1..#{count}).map { |i| @__#{method_name}_block.call(self, i) }
                else
                  original_value = #{method_name}= @__#{method_name}_block.call(self)
                end
                @__#{method_name}_block = nil
                @__#{method_name}_original.call
              end
              original_value
            end
          >
        else
          assign(instance, method_name, args.first, &block)
        end
      else
        assign(instance, method_name, args)
      end
    end
  end

end
