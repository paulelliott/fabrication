require 'spec_helper'

describe Fabrication::Generator::DataMapper do
  describe '.supports?' do
    subject { Fabrication::Generator::DataMapper }

    it 'returns true for datamapper objects' do
      subject.supports?(Movie).should be_true
    end

    it 'returns false for non-datamapper objects objects' do
      subject.supports?(Company).should be_false
    end
  end
end
