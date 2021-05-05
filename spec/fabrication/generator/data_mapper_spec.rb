require 'spec_helper'

describe Fabrication::Generator::DataMapper, depends_on: :data_mapper do
  describe '.supports?' do
    it 'returns true for datamapper objects' do
      expect(described_class.supports?(ParentDataMapperModel)).to be true
    end

    it 'returns false for non-datamapper objects objects' do
      expect(described_class.supports?(ParentRubyObject)).to be false
    end
  end
end
