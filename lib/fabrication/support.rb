class Fabrication::Support

  class << self

    def fabricatable?(name)
      Fabrication.manager[name] || class_for(name)
    end

    def class_for(class_or_to_s)
      class_name = variable_name_to_class_name(class_or_to_s)
      klass = class_name.split('::').inject(Object) do |object, string|
        object.const_get(string)
      end
    rescue NameError => original_error
      raise Fabrication::UnfabricatableError.new(class_or_to_s, original_error)
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

  end

end
