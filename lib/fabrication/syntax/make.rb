module Fabrication
  module Syntax

    # Extends Fabrication to provide make/make! class methods, which are
    # shortcuts for Fabricate.build/Fabricate.
    #
    # Usage:
    #
    # require 'fabrication/syntax/make'
    #
    # User.make(:name => 'Johnny')
    #
    #
    module Make
      def make(*args, &block)
        overrides = Fabrication::Support.extract_options!(args)
        klass = name.underscore.to_sym
        fabricator_name = args.first.is_a?(Symbol) ? "#{klass}_#{args.first}" : klass
        Fabricate.build(fabricator_name, overrides, &block)
      end

      def make!(*args, &block)
        overrides = Fabrication::Support.extract_options!(args)
        klass = name.underscore.to_sym
        fabricator_name = args.first.is_a?(Symbol) ? "#{klass}_#{args.first}" : klass
        Fabricate(fabricator_name, overrides, &block)
      end
    end
  end
end

Object.extend Fabrication::Syntax::Make
