module Fabrication
  module Cucumber
    class StepFabricator

      def initialize(model_name, opts ={})
        @model = dehumanize(model_name)
        @fabricator = @model.singularize.to_sym
        @parent_name = opts.delete(:parent)
      end

      def from_table(table, extra={})
        hashes = singular? ? [table.rows_hash] : table.hashes
        objects = hashes.map do |hash|
          make(parameterize_hash(hash).merge(extra))
        end
        remember(objects)
        objects
      end

      def n(count, extra={})
        count.times.map { make(extra) }.tap {|o| remember(o) }
      end

      def one(extra={})
        make(extra).tap {|o| remember([o]) }
      end

      def make(attrs={})
        Fabricate(@fabricator, attrs.merge(parentship))
      end

      def parentship
        return {} unless parent
        parent_class_name = parent.class.to_s.underscore

        parent_instance = parent
        unless klass.new.respond_to?("#{parent_class_name}=")
          parent_class_name = parent_class_name.pluralize
          parent_instance = [parent]
        end

        { parent_class_name => parent_instance }
      end

      def has_many(children)
        instance = Fabrications[@fabricator]
        children = dehumanize(children)
        [Fabrications[children]].flatten.each do |child|
          child.send("#@model=", instance)
          child.respond_to?(:save!) && child.save!
        end
      end

      def parent
        return unless @parent_name
        Fabrications[dehumanize(@parent_name)]
      end

      def klass
        schematic.klass
      end

      def schematic
        Fabrication::Fabricator.schematics[@fabricator]
      end

      def remember(objects)
        if singular?
          Fabrications[@fabricator] = objects.last
        else
          Fabrications[@model.to_sym] = objects
        end
      end

      def singular?
        @model == @model.singularize
      end

      private
      def dehumanize(string)
        string.gsub(/\W+/,'_').downcase
      end
      def parameterize_hash(hash)
        hash.inject({}) {|h,(k,v)| h.update(dehumanize(k).to_sym => v)}
      end
    end

    module Fabrications
      @@fabrications = {}

      def self.[](fabricator)
        @@fabrications[fabricator.to_sym]
      end

      def self.[]=(fabricator, fabrication)
        @@fabrications[fabricator.to_sym] = fabrication
      end
    end
  end
end

module FabricationMethods
  def fabrications
    Fabrication::Cucumber::Fabrications
  end
end

World(FabricationMethods)
