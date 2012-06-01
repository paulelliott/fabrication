require 'spec_helper'
require 'fabrication/syntax/make'

describe Fabrication::Syntax::Make do

  describe "#make mongoid" do

    it "should return a fabricated object" do
      Author.make.should be_instance_of Author
    end

    it "should overwrite options" do
      Author.make(:name => "N.Rodrigues").name.should eql("N.Rodrigues")
    end

    it "should treat a first non-hash argument as fabrication name suffix" do
      Author.make(:with_handle, :name => "Eric Arthur Blair").handle.should eql("@1984")
    end

    it "should work the same as Fabricate.build" do
      Author.make.should be_new_record
    end

    it "bang should be the same as Fabricate" do
      Author.make!.should_not be_new_record
    end

  end

  describe "#make activerecord" do

    it "should return a fabricated object" do
      Company.make.should be_instance_of Company
    end

    it "should work the same as Fabricate.build" do
      Company.make.should be_new_record
    end

    it "bang should be the same as Fabricate" do
      Company.make!.should_not be_new_record
    end

  end

  describe "#make sequel" do

    it "should return a fabricated object" do
      ParentSequelModel.make.should be_instance_of ParentSequelModel
    end

    it "should be the same as Fabricate.build" do
      ParentSequelModel.make.should eql(Fabricate.build(:parent_sequel_model))
    end

    it "bang should be the same as Fabricate" do
      ParentSequelModel.make!.id.should_not be_nil
    end
  end

end
