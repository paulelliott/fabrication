require 'spec_helper'

describe Fabrication::Config do
  subject { Fabrication::Config }
  after { Fabrication::Config.reset_defaults }

  context "default configs" do
    its(:fabricator_path) { should == ['test/fabricators', 'spec/fabricators'] }
    its(:sequence_start) { should == 0 }
  end

  describe ".fabricator_path" do
    context "with a single folder" do
      before do
        Fabrication.configure do |config|
          config.fabricator_path = 'lib'
        end
      end

      its(:fabricator_path) { should == ['lib'] }
    end

    context "with multiple folders" do
      before do
        Fabrication.configure do |config|
          config.fabricator_path = %w(lib support)
        end
      end

      its(:fabricator_path) { should == ['lib', 'support'] }
    end
  end
end
