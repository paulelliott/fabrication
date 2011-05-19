require 'spec_helper'

describe Fabrication::Config do
  subject { Fabrication::Config }
  after { Fabrication::Config.reset_defaults }

  context "default configs" do
    its(:fabricator_dir) { should == ['test', 'spec'] }
  end

  describe ".fabricator_dir" do
    context "with a single folder" do
      before do
        Fabrication::Config.fabricator_dir = 'lib'
      end

      its(:fabricator_dir) { should == ['lib'] }
    end

    context "with multiple folders" do
      before do
        Fabrication::Config.fabricator_dir = %w(lib support)
      end

      its(:fabricator_dir) { should == ['lib', 'support'] }
    end
  end
end
