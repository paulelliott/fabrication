require 'rails/generators/base'

module Fabrication
  module Generators
    class TurnipStepsGenerator < Rails::Generators::Base
      argument :step_dir, :type => :string, :default => "spec/acceptance/steps/"

      def generate
        template 'fabrication_steps.rb', turnip_step_directory
      end

      def self.source_root
        @_fabrication_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      private

      def turnip_step_directory
        File.join(step_dir, 'fabrication_steps.rb')
      end
    end
  end
end
