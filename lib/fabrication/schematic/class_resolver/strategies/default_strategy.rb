module Fabrication
  module Schematic
    class DefaultResolver < ResolverStrategy
      def resolve_class
        Fabrication::Support.class_for(
          (parent && parent.klass) ||
          options[:from] ||
          name
        )
      end
    end
  end
end
