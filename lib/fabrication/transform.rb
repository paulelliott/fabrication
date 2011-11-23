class Fabrication::Transform

  class << self

    def apply(attributes_hash)
      attributes_hash.inject({}) {|h,(k,v)| h.update(k => transforms[k].call(v)) }
    end

    def clear_all
      @@transforms = nil
    end

    def define(attribute, transform)
      transforms[attribute] = transform
    end

    private

    def transforms
      @@transforms ||= Hash.new(lambda {|value| value})
    end

  end

end
