class Fabrication::Transform

  class << self

    def apply_to(schematic, attributes_hash)
      Fabrication::Support.find_definitions if Fabrication.schematics.empty?
      attributes_hash.inject({}) {|h,(k,v)| h.update(k => apply_transform(schematic, k, v)) }
    end

    def clear_all
      @transforms = nil
      @overrides = nil
    end

    def define(attribute, transform)
      transforms[attribute] = transform
    end

    def only_for(schematic, attribute, transform)
      overrides[schematic] = (overrides[schematic] || {}).merge!(attribute => transform)
    end

    private

    def overrides
      @overrides ||= {}
    end

    def apply_transform(schematic, attribute, value)
      overrides.fetch(schematic, transforms)[attribute].call(value)
    end

    def transforms
      @transforms ||= Hash.new(lambda {|value| value})
    end

  end

end
