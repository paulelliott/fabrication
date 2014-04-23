require 'spec_helper'
require 'fabrication/syntax/make'

describe Fabrication::Syntax::Make do

  describe "#make mongoid", depends_on: :mongoid do
    it "should return a fabricated object" do
      ParentMongoidDocument.make.should be_instance_of ParentMongoidDocument
    end

    it "should overwrite options" do
      ParentMongoidDocument.make(string_field: "N.Rodrigues").string_field.should eql("N.Rodrigues")
    end

    it "should treat a first non-hash argument as fabrication name suffix" do
      Fabricator(:parent_mongoid_document_with_handle, from: :parent_mongoid_document)
      ParentMongoidDocument.make(:with_handle).string_field.should eql("content")
    end

    it "should work the same as Fabricate.build" do
      ParentMongoidDocument.make.should be_new_record
    end

    it "bang should be the same as Fabricate" do
      ParentMongoidDocument.make!.should_not be_new_record
    end
  end

  describe "#make activerecord", depends_on: :active_record do

    it "should return a fabricated object" do
      ParentActiveRecordModel.make.should be_instance_of ParentActiveRecordModel
    end

    it "should work the same as Fabricate.build" do
      ParentActiveRecordModel.make.should be_new_record
    end

    it "bang should be the same as Fabricate" do
      ParentActiveRecordModel.make!.should_not be_new_record
    end

  end

  describe "#make sequel", depends_on: :sequel do
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
