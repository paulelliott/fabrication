require 'spec_helper'

describe Fabrication::Generator::DataMapper, depends_on: :data_mapper do
  describe '.supports?' do
    subject { Fabrication::Generator::DataMapper }

    it 'returns true for datamapper objects' do
      subject.supports?(ParentDataMapperModel).should be_true
    end

    it 'returns false for non-datamapper objects objects' do
      subject.supports?(ParentRubyObject).should be_false
    end
  end
end
