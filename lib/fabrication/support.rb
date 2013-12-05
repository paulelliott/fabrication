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
    rescue NameError
    ensure
      raise Fabrication::UnfabricatableError.new(class_or_to_s) unless klass
    end

    def extract_options!(args)
      args.last.is_a?(::Hash) ? args.pop : {}
    end

    def variable_name_to_class_name(name)
      name.to_s.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
    end

    def find_definitions
      Fabrication.manager.preinitialize
      Fabrication::Config.path_prefix.each do |prefix|
        Fabrication::Config.fabricator_path.each do |folder|
          Dir.glob(File.join(prefix, folder, '**', '*.rb')).sort.each do |file|
            load file
          end
        end
      end
    rescue Exception => e
      raise e
    ensure
      Fabrication.manager.freeze
    end

    def hash_class
      @hash_class ||= defined?(HashWithIndifferentAccess) ? HashWithIndifferentAccess : Hash
    end

  end

end
