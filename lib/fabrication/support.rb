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
      path_prefix = defined?(Rails) ? (find_engine_path || Rails.root) : "."
      Fabrication::Config.fabricator_dir.each do |folder|
        Dir.glob(File.join(path_prefix, folder, '**', '*.rb')).sort.each do |file|
          load file
        end
      end
      Fabrication.schematics.freeze
    end

    private
      def find_engine_path
        match = Rails.root.to_s.match /(.*)\/(spec|test)\/dummy$/
        if match
          maybe_engine_path = match[1]
          if Rails.application.railties.engines.map{|e| e.root.to_s}.delete_if do |e|
              e != maybe_engine_path
            end.size == 1
            maybe_engine_path
          else
            nil
          end
        else
          nil
        end
      end
  end
end
