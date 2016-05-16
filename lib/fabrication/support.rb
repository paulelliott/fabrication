class Fabrication::Support

  class << self

    def fabricatable?(name)
      Fabrication.manager[name] || class_for(name)
    end

    def class_for(class_or_to_s)
      class_name = variable_name_to_class_name(class_or_to_s)
      constantize(class_name)
    rescue NameError => original_error
      raise Fabrication::UnfabricatableError.new(class_or_to_s, original_error)
    end

    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      Object.const_get(camel_cased_word) if names.empty?
      names.shift if names.size > 1 && names.first.empty?
      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)
          constant = constant.ancestors.inject do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end
          constant.const_get(name, false)
        end
      end
    end

    def extract_options!(args)
      args.last.is_a?(::Hash) ? args.pop : {}
    end

    def variable_name_to_class_name(name)
      name.to_s.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
    end

    def find_definitions
      puts "DEPRECATION WARNING: Fabrication::Support.find_definitions has been replaced by Fabrication.manager.load_definitions and will be removed in 3.0.0."
      Fabrication.manager.load_definitions
    end

    def hash_class
      @hash_class ||= defined?(HashWithIndifferentAccess) ? HashWithIndifferentAccess : Hash
    end

    def singularize(string)
      string.singularize
    rescue
      string.end_with?('s') ? string[0..-2] : string
    end

    def underscore(string)
      string.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

  end

end
