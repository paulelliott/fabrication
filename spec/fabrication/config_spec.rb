require 'spec_helper'

describe Fabrication::Config do
  subject { Fabrication::Config }

  context "default configs" do
    its(:fabricator_dir) { should == ['test/fabricators', 'spec/fabricators'] }
  end

  describe ".fabricator_dir" do
    context "with a single folder" do
      before do
        Fabrication::Config.fabricator_dir = 'lib/fabricators'
      end

      its(:fabricator_dir) { should == ['lib/fabricators'] }
    end
  end
end
