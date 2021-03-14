class Fabrication::Sequencer
  DEFAULT = :_default

  def self.sequence(name = DEFAULT, start = nil, &block)
    idx = sequences[name] ||= start || Fabrication::Config.sequence_start
    if block_given?
      sequence_blocks[name] = block.to_proc
    else
      sequence_blocks[name] ||= ->(i) { i }
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
    Fabrication::Config.sequence_start = nil
    @sequences = nil
    @sequence_blocks = nil
  end
end
