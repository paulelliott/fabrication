require 'rails/generators/named_base'

module Fabrication
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      class_option :dir, :type => :string, :default => "spec/fabricators", :desc => "The directory where the fabricators should go"
      class_option :extension, :type => :string, :default => "rb", :desc => "file extension name"

      def create_fabrication_file
        copy_attributes_from_model if attributes.empty?
        template_file = File.join(
          options[:dir],
          class_path,
          "#{file_name}_fabricator.#{options[:extension].to_s}"
        )
        template 'fabricator.erb', template_file
      end

      def self.source_root
        @_fabrication_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      private

      def copy_attributes_from_model
        model = class_name.constantize
        if defined?(ActiveRecord) && model < ActiveRecord::Base
          self.attributes = model.columns_hash.map { |name, column|
            Rails::Generators::GeneratedAttribute.new(name, column.type)
          }
        end
      rescue
        # no table? no problem!
      end

    end
  end
end
