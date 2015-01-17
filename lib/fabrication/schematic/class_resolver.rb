module Fabrication
  module Schematic
    class ClassResolver
      def self.create(name, parent, options)
        if options[:class_name]
          Fabrication::Schematic::ExplicitResolver.new(name, parent, options)
        else
          Fabrication::Schematic::DefaultResolver.new(name, parent, options)
        end
      end
    end
  end
end
