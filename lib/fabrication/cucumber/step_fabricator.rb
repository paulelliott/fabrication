module Fabrication
  module Cucumber
    class StepFabricator
      attr_reader :model

      def initialize(model_name, opts ={})
        @model = dehumanize(model_name)
        @fabricator = Fabrication::Support.singularize(@model).to_sym
        @parent_name = opts.delete(:parent)
      end

      def from_table(table, extra={})
        hashes = singular? ? [table.rows_hash] : table.hashes
        hashes.map do |hash|
          transformed_hash = Fabrication::Transform.apply_to(@model, parameterize_hash(hash))
          make(transformed_hash.merge(extra))
        end.tap {|o| remember(o) }
      end

      def n(count, attrs={})
        count.times.map { make(attrs) }.tap {|o| remember(o) }
      end

      def has_many(children)
        instance = Fabrications[@fabricator]
        children = dehumanize(children)
        [Fabrications[children]].flatten.each do |child|
          child.send("#{klass.to_s.underscore.downcase}=", instance)
          child.respond_to?(:save!) && child.save!
        end
      end

      def parent
        return unless @parent_name

        Fabrications[dehumanize(@parent_name)]
      end

      def klass
        Fabricate.schematic(@fabricator).send(:klass)
      end

      private

      def remember(objects)
        if singular?
          Fabrications[@fabricator] = objects.last
        else
          Fabrications[@model.to_sym] = objects
        end
      end

      def singular?
        @model == Fabrication::Support.singularize(@model)
      end

      def dehumanize(string)
        string.gsub(/\W+/,'_').downcase
      end

      def parameterize_hash(hash)
        hash.inject({}) {|h,(k,v)| h.update(dehumanize(k).to_sym => v)}
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
