require 'spec_helper'

describe Fabricator do

  describe ".name_for" do

    it "delegates to Fabrication::Support" do
      Fabrication::Support.should_receive(:name_for).with("interesting location")
      Fabricator.name_for("interesting location")
    end

  end

end
