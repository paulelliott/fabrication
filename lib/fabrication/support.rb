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
      path_prefix = rails_defined? ? (find_engine_path || rails_root) : "."

      Fabrication::Config.fabricator_dir.each do |folder|
        Dir.glob(File.join(path_prefix, folder, '**', '*.rb')).sort.each do |file|
          load file
        end
      end
      Fabrication.schematics.freeze
    end

    private
      def find_engine_path
        return nil unless rails_defined?
        match = rails_root.to_s.match(/(.*)\/(spec|test)\/dummy$/)

        return nil unless match

        possible_engine_path = match[1]
        irrelevant_engines = find_rails_engines.delete_if { |engine_path| engine_path != possible_engine_path }
        return possible_engine_path if irrelevant_engines.size == 1

        nil
      end

      def rails_defined?
        defined?(Rails)
      end

      def rails_root
        Rails.root        
      end

      def find_rails_engines
        Rails.application.railties.engines.map{ |e| e.root.to_s }
      end
  end
end
