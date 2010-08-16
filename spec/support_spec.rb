require 'spec_helper'

describe Fabrication::Support do

  describe ".class_for" do

    context "with a class that exists" do

      it "returns the class for a class" do
        Fabrication::Support.class_for(Object).should == Object
      end

      it "returns the class for a class name string" do
        Fabrication::Support.class_for('object').should == Object
      end

      it "returns the class for a class name symbol" do
        Fabrication::Support.class_for(:object).should == Object
      end

    end

    context "with a class that doesn't exist" do

      it "returns nil for a class name string" do
        Fabrication::Support.class_for('your_mom').should be_nil
      end

      it "returns nil for a class name symbol" do
        Fabrication::Support.class_for(:your_mom).should be_nil
      end

    end

  end

  describe ".find_definitions" do

    before(:all) do
      File.open("spec/fabricators.rb", "w") do |f|
        f.write("Fabricator(:awesome_object, :from => :object)")
      end
      File.open("spec/fabricators/cool_object.rb", "w") do |f|
        f.write("Fabricator(:cool_object, :from => :object)")
      end
      Fabrication::Support.find_definitions
      File.delete("spec/fabricators.rb")
      File.delete("spec/fabricators/cool_object.rb")
    end

    it "has an awesome object" do
      Fabrication::Fabricator.schematics[:awesome_object].should be
    end

    it "has a cool object" do
      Fabrication::Fabricator.schematics[:cool_object].should be
    end

  end

end
