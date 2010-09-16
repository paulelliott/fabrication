class Fabrication::Sequencer

  class << self

    def sequence(name, start=0)
      idx = sequences[name] ||= start

      (block_given? ? yield(idx) : idx).tap do
        sequences[name] += 1
      end
    end

    def sequences
      @sequences ||= {}
    end

  end

end
