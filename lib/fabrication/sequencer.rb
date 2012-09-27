class Fabrication::Sequencer

  DEFAULT = :_default

  def self.default_sequence_start(value)
    @default_sequence_start = value
  end

  def self.sequence(name=DEFAULT, start=nil, &block)
    idx = sequences[name] ||= start || @default_sequence_start || 0
    if block_given?
      sequence_blocks[name] = block.to_proc
    else
      sequence_blocks[name] ||= lambda { |i| i }
    end.call(idx).tap do
      sequences[name] += 1
    end
  end

  def self.sequences
    @sequences ||= {}
  end

  def self.sequence_blocks
    @sequence_blocks ||= {}
  end

  def self.reset
    @sequences = nil
    @sequence_blocks = nil
    @default_sequence_start = nil
  end
end
