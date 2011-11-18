require 'rails/generators/base'

module Fabrication::Generators
  class TurnipStepsGenerator < Rails::Generators::Base

    def generate
      template 'fabrication_steps.rb', "spec/acceptance/steps/fabrication_steps.rb"
    end

    def self.source_root
      @_fabrication_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end

  end
end
