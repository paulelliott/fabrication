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
    before(:each) do
      Fabrication.clear_definitions
    end
    describe "Rails app" do
      it "loaded definitions" do
        Fabrication::Support.find_definitions
        Fabrication.schematics[:parent_ruby_object].should be
      end
    end

    describe "Engine" do
      it "should load the engine path" do
        engine_root = "."
        dummy_application_root = File.join(engine_root, "spec", "dummy")
        
        Fabrication::Support.stub!(:rails_defined?).and_return(true)
        Fabrication::Support.stub!(:rails_root).and_return(dummy_application_root)
        Fabrication::Support.stub!(:find_rails_engines).and_return(['/', engine_root])

        Fabrication::Support.find_definitions
        Fabrication.schematics[:parent_ruby_object].should be
      end
    end
  end

end
