require 'rails/generators/named_base'

module Fabrication
  module Generators
    class Base < Rails::Generators::NamedBase #:nodoc:
      def self.source_root
        @_fabrication_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'fabrication', generator_name, 'templates'))
      end
    end
  end
end