module Fabrication
  module Schematic
    class ResolverStrategy
      attr_reader :name, :parent, :options

      def initialize(name, parent, options)
        @name = name
        @parent = parent
        @options = options
      end

      def resolve_class
        raise NotImplementedError
      end
    end
  end
end
