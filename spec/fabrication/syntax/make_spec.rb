require 'spec_helper'
require 'fabrication/syntax/make'

describe Fabrication::Syntax::Make do

  describe "#make mongoid", depends_on: :mongoid do
    it "should return a fabricated object" do
      expect(ParentMongoidDocument.make).to be_instance_of ParentMongoidDocument
    end

    it "should overwrite options" do
      expect(ParentMongoidDocument.make(string_field: "N.Rodrigues").string_field).to eql("N.Rodrigues")
    end

    it "should treat a first non-hash argument as fabrication name suffix" do
      Fabricator(:parent_mongoid_document_with_handle, from: :parent_mongoid_document)
      expect(ParentMongoidDocument.make(:with_handle).string_field).to eql("content")
    end

    it "should work the same as Fabricate.build" do
      expect(ParentMongoidDocument.make).to be_new_record
    end

    it "bang should be the same as Fabricate" do
      expect(ParentMongoidDocument.make!).not_to be_new_record
    end
  end

  describe "#make activerecord", depends_on: :active_record do

    it "should return a fabricated object" do
      expect(ParentActiveRecordModel.make).to be_instance_of ParentActiveRecordModel
    end

    it "should work the same as Fabricate.build" do
      expect(ParentActiveRecordModel.make).to be_new_record
    end

    it "bang should be the same as Fabricate" do
      expect(ParentActiveRecordModel.make!).not_to be_new_record
    end

  end

  describe "#make sequel", depends_on: :sequel do
    it "should return a fabricated object" do
      expect(ParentSequelModel.make).to be_instance_of ParentSequelModel
    end

    it "should be the same as Fabricate.build" do
      expect(ParentSequelModel.make).to eql(Fabricate.build(:parent_sequel_model))
    end

    it "bang should be the same as Fabricate" do
      expect(ParentSequelModel.make!.id).not_to be_nil
    end
  end

end
