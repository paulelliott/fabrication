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
      def make(overrides = {}, &block)
        Fabricate.build(name.underscore.to_sym, overrides, &block)
      end

      def make!(overrides = {}, &block)
        Fabricate(name.underscore.to_sym, overrides, &block)
      end
    end
  end
end

Object.extend Fabrication::Syntax::Make
