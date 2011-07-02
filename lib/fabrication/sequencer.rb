class Fabrication::Sequencer

  DEFAULT = :_default

  def self.sequence(name=DEFAULT, start=0)
    idx = sequences[name] ||= start

    (block_given? ? yield(idx) : idx).tap do
      sequences[name] += 1
    end
  end

  def self.sequences
    @sequences ||= {}
  end

end
