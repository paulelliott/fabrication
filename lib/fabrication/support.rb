class Fabrication::Support

  class << self

    def fabricatable?(name)
      Fabrication.schematics[name] || class_for(name)
    end

    def class_for(class_or_to_s)
      if class_or_to_s.respond_to?(:to_sym)
        class_name = variable_name_to_class_name(class_or_to_s)
        class_name.split('::').inject(Object) do |object, string|
          object.const_get(string)
        end
      else
        class_or_to_s
      end
    rescue NameError
    end

    def extract_options!(args)
      args.last.is_a?(::Hash) ? args.pop : {}
    end

    def variable_name_to_class_name(name)
      name.to_s.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
    end

    def find_definitions
      Fabrication.schematics.preinitialize
      Fabrication::Config.fabricator_dir.each do |folder|
        Dir.glob(File.join(Fabrication::Config.path_prefix, folder, '**', '*.rb')).sort.each do |file|
          load file
        end
      end
      Fabrication.schematics.freeze
    end

    def hash_class
      @hash_class ||= defined?(HashWithIndifferentAccess) ? HashWithIndifferentAccess : Hash
    end

  end

end
