require 'spec_helper'

describe Fabrication::Transform do
  before do
    Fabrication.clear_definitions
    described_class.clear_all
  end

  describe '.apply_to' do
    context 'with find definitions' do
      context 'when transforms are empty' do
        it 'loads the definitions' do
          expect(Fabrication.manager).to receive(:load_definitions)
          described_class.apply_to(nil, name: 'Shay')
        end
      end

      context 'when transforms are not empty' do
        it 'does not load the definitions' do
          described_class.apply_to(nil, name: 'Shay')
          expect(Fabrication.manager).not_to receive(:load_definitions)
          described_class.apply_to(nil, name: 'Gabriel')
        end
      end
    end

    context 'when there is a generic transform for that column' do
      before do
        described_class.define(:city, ->(value) { value.split.first })
      end

      context 'when fabricating an instance that is described by the per fabricator transform' do
        before do
          described_class.only_for(:address, :city, ->(value) { value.upcase })
        end

        it 'applies the transform to the specified types' do
          expect(described_class.apply_to(
                   :address,
                   { city: 'Jacksonville Beach' }
                 )).to eq({ city: 'JACKSONVILLE BEACH' })
        end
      end

      context 'when no override has been defined' do
        it 'applies the generic transform' do
          expect(described_class.apply_to(
                   :address,
                   { city: 'Jacksonville Beach' }
                 )).to eq({ city: 'Jacksonville' })
        end
      end
    end

    context 'when no generic transform has been defined' do
      it 'does not change value' do
        expect(described_class.apply_to(
                 :address,
                 { city: 'Jacksonville Beach' }
               )).to eq({ city: 'Jacksonville Beach' })
      end
    end

    context 'when ensuring precedence' do
      context 'when override is done before generic transform' do
        before do
          described_class.only_for(:address, :city, ->(value) { value.upcase })
          described_class.define(:city, ->(value) { value.split.first })
        end

        it 'applies corretly' do
          expect(described_class.apply_to(
                   :address,
                   { city: 'Jacksonville Beach' }
                 )).to eq({ city: 'JACKSONVILLE BEACH' })
        end
      end
    end
  end

  describe '.clear_all' do
    it 'clears all transforms' do
      described_class.define(:name, ->(value) { value })
      described_class.only_for(:address, :name, ->(value) { value })
      described_class.clear_all
      expect(described_class.send(:transforms)).to be_empty
      expect(described_class.send(:overrides)).to be_empty
    end
  end

  describe '.define' do
    it 'registers transform' do
      expect do
        described_class.define(:name, ->(value) { value })
      end.to change(described_class, :transforms)
    end
  end

  describe '.only_for' do
    it 'registers an override transform for provided model' do
      expect do
        described_class.only_for(:address, :name, ->(value) { value })
      end.to change(described_class, :overrides)
    end
  end
end
