class Fabrication::Support

  class << self

    def fabricatable?(name)
      Fabrication::Fabricator.schematics.include?(name) || class_for(name)
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

    def variable_name_to_class_name(name)
      name.to_s.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
    end

    def find_definitions
      base_path = defined?(Rails) ? Rails.root : "."
      ['test', 'spec'].map do |folder|
        path = File.expand_path(File.join(base_path, folder, 'fabricators'))

        load("#{path}.rb") if File.exists?("#{path}.rb")

        File.directory? path and Dir[File.join(path, '*.rb')].each do |file|
          load file
        end
      end
    end

  end

end
