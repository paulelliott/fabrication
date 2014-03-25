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
        lambda { Fabrication::Support.class_for('your_mom') }.
          should raise_error(Fabrication::UnfabricatableError)
      end

      it "returns nil for a class name symbol" do
        lambda { Fabrication::Support.class_for(:your_mom) }.
          should raise_error(Fabrication::UnfabricatableError)
      end

      context "and custom const_missing is defined" do
        before do
          module Family
            def self.const_missing(name)
              raise NameError, "original message"
            end
          end
        end

        it "raises an exception with the message from the original exception" do
          lambda { Fabrication::Support.class_for("Family::Mom") }.
            should raise_error(Fabrication::UnfabricatableError, /original message/)
        end
      end
    end
  end

  describe ".find_definitions" do
    before { Fabrication.clear_definitions }

    context 'happy path' do
      it "loaded definitions" do
        Fabrication::Support.find_definitions
        Fabrication.manager[:parent_ruby_object].should be
      end
    end

    context 'when an error occurs during the load' do
      it 'still freezes the manager' do
        Fabrication::Config.should_receive(:fabricator_path).and_raise(Exception)
        expect { Fabrication::Support.find_definitions }.to raise_error
        Fabrication.manager.should_not be_initializing
      end
    end

  end

  describe '.hash_class', depends_on: :active_support do
    subject { Fabrication::Support.hash_class }

    context 'with HashWithIndifferentAccess defined' do
      it { should == HashWithIndifferentAccess }
    end

    context 'without HashWithIndifferentAccess defined' do
      before do
        TempHashWithIndifferentAccess = HashWithIndifferentAccess
        Fabrication::Support.instance_variable_set('@hash_class', nil)
        Object.send(:remove_const, :HashWithIndifferentAccess)
      end
      after do
        Fabrication::Support.instance_variable_set('@hash_class', nil)
        HashWithIndifferentAccess = TempHashWithIndifferentAccess
      end
      it { should == Hash }
    end
  end

end
