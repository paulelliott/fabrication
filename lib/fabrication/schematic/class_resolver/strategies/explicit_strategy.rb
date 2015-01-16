module Fabrication
  module Schematic
    class ExplicitResolver < ResolverStrategy
      def resolve_class
        class_name = options[:class_name]

        return class_name if class_name.is_a?(Class)
        begin
          Fabrication::Support.constantize(class_name)
        rescue
          Fabrication::Support.class_for(class_name)
        end
      end
    end
  end
end
