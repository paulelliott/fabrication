require 'spec_helper'

describe Fabrication::Config do
  subject { described_class }

  after { described_class.reset_defaults }

  context 'with default configs' do
    its(:fabricator_path) { should == ['test/fabricators', 'spec/fabricators'] }
    its(:path_prefix) { should == ['.'] }
    its(:sequence_start) { should == 0 }
  end

  describe '.fabricator_path' do
    context 'with a single folder' do
      before do
        Fabrication.configure do |config|
          config.fabricator_path = 'lib'
        end
      end

      its(:fabricator_path) { should == ['lib'] }
    end

    context 'with multiple folders' do
      before do
        Fabrication.configure do |config|
          config.fabricator_path = %w[lib support]
        end
      end

      its(:fabricator_path) { should == %w[lib support] }
    end
  end

  describe '.path_prefix' do
    context 'with a single folder' do
      before do
        Fabrication.configure do |config|
          config.path_prefix = '/path/to/app'
        end
      end

      its(:path_prefix) { should == ['/path/to/app'] }
    end

    context 'with multiple folders' do
      before do
        Fabrication.configure do |config|
          config.path_prefix = %w[/path/to/app /path/to/gem/fabricators]
        end
      end

      its(:path_prefix) { should == ['/path/to/app', '/path/to/gem/fabricators'] }
    end
  end

  describe '.register_generator' do
    before do
      Fabrication.configure do |config|
        config.generators << ImmutableGenerator
      end
    end

    its(:generators) { should == [ImmutableGenerator] }
  end
end
