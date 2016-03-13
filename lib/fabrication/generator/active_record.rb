class Fabrication::Generator::ActiveRecord < Fabrication::Generator::Base

  def self.supports?(klass)
    defined?(ActiveRecord) && klass.ancestors.include?(ActiveRecord::Base)
  end

  def build_instance
    if _klass.respond_to?(:protected_attributes)
      self._instance = _klass.new(_attributes, without_protection: true)
    else
      self._instance = _klass.new(_attributes)
    end
  end

  def build_default_expansion(field_name, params)
    # When an inverse field is found, we can override this in the fabricator so we
    # don't run into an endless recursion
    build_args = {}
    if inverse_of = inverse_of(field_name)
      inverse_name = inverse_of.name.to_s
      if belongs_to_or_has_one?(inverse_of)
        build_args[inverse_name] = nil
      else
        build_args[inverse_name] = []
      end
    end

    if params[:count]
      fabricator_name = params[:fabricator] || Fabrication::Support.singularize(field_name.to_s)
      proc { Fabricate.build(params[:fabricator] || fabricator_name, build_args) }
    else
      fabricator_name = params[:fabricator] || field_name
      proc { Fabricate(params[:fabricator] || fabricator_name, build_args) }
    end
  end

  private

  # Returns the inverse field name of a given relation
  def inverse_of(name)
    reflection = _klass.reflections.fetch(name.to_s, nil) || # >= Rails 4.3
      _klass.reflections.fetch(name.to_sym, nil) # < Rails 4.3
    reflection.inverse_of if reflection
  end

  # Returns true if the reflection is a belongs_to or has_one association
  def belongs_to_or_has_one?(reflection)
    if reflection.respond_to?(:macro) # < Rails 4.3
      return true if reflection.macro == :belongs_to || reflection.macro == :has_one
    else # >= Rails 5.3
      return true if reflection.instance_of?(ActiveRecord::Reflection::BelongsToReflection) ||
        reflection.instance_of?(ActiveRecord::Reflection::HasOneReflection)
    end
  end
end
