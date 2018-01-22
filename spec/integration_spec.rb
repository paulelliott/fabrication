require 'spec_helper'

shared_examples 'something fabricatable' do
  subject { fabricated_object }
  let(:fabricated_object) { Fabricate(fabricator_name, placeholder: 'dynamic content') }

  context 'defaults from fabricator' do
    its(:dynamic_field) { should == 'dynamic content' }
    its(:nil_field) { should be_nil }
    its(:number_field) { should == 5 }
    its(:string_field) { should == 'content' }
    its(:false_field) { should == false }
  end

  context 'model callbacks are fired' do
    its(:before_validation_value) { should == 1 }
    its(:before_save_value) { should == 11 }
  end

  context 'overriding at fabricate time' do
    let(:fabricated_object) do
      Fabricate(
        "#{fabricator_name}_with_children",
        string_field: 'new content',
        number_field: 10,
        nil_field: nil,
        placeholder: 'is not invoked'
      ) do
        dynamic_field { 'new dynamic content' }
      end
    end

    its(:dynamic_field) { should == 'new dynamic content' }
    its(:nil_field) { should be_nil }
    its(:number_field) { should == 10 }
    its(:string_field) { should == 'new content' }

    context 'child collections' do
      subject { fabricated_object.send(collection_field) }
      its(:size) { should == 2 }
      its(:first) { should be_persisted }
      its("first.number_field") { should == 10 }
      its(:last) { should be_persisted }
      its("last.number_field") { should == 10 }
    end
  end

  context 'state of the object' do
    it 'generates a fresh object every time' do
      expect(Fabricate(fabricator_name)).not_to eq(subject)
    end
    it { should be_persisted }
  end

  context 'transient attributes' do
    it { should_not respond_to(:placeholder) }
    its(:extra_fields) { should == { transient_value: 'dynamic content' } }
  end

  context 'build' do
    subject { Fabricate.build("#{fabricator_name}_with_children") }
    it { should_not be_persisted }

    it 'cascades to child records' do
      subject.send(collection_field).each do |o|
        expect(o).not_to be_persisted
      end
    end
  end

  context 'attributes for' do
    subject { Fabricate.attributes_for(fabricator_name) }
    it { should be_kind_of(Fabrication::Support.hash_class) }
    it 'serializes the attributes' do
      should include({
        :dynamic_field => nil,
        :nil_field => nil,
        :number_field => 5,
        :string_field => 'content'
      })
    end
  end

  context 'belongs_to associations' do
    subject { Fabricate("#{Fabrication::Support.singularize(collection_field.to_s)}_with_parent") }

    it 'sets the parent association' do
      expect(subject.send(fabricator_name)).to be
    end

    it 'sets the id of the associated object' do
      expect(subject.send("#{fabricator_name}_id")).to eq(subject.send(fabricator_name).id)
    end
  end
end

describe Fabrication do

  context 'plain old ruby objects' do
    let(:fabricator_name) { :parent_ruby_object }
    let(:collection_field) { :child_ruby_objects }
    it_should_behave_like 'something fabricatable'
  end

  context 'active_record models', depends_on: :active_record do
    let(:fabricator_name) { :parent_active_record_model }
    let(:collection_field) { :child_active_record_models }
    it_should_behave_like 'something fabricatable'

    context 'associations in attributes_for' do
      let(:parent_model) { Fabricate(:parent_active_record_model) }
      subject do
        Fabricate.attributes_for(:child_active_record_model, parent_active_record_model: parent_model)
      end

      it 'serializes the belongs_to as an id' do
        should include({ parent_active_record_model_id: parent_model.id })
      end
    end

    context 'association proxies' do
      subject { parent_model.child_active_record_models.build }
      let(:parent_model) { Fabricate(:parent_active_record_model_with_children) }
      it { should be_kind_of(ChildActiveRecordModel) }
    end
  end

  context 'data_mapper models', depends_on: :data_mapper do
    let(:fabricator_name) { :parent_data_mapper_model }
    let(:collection_field) { :child_data_mapper_models }

    it_should_behave_like 'something fabricatable'

    context 'associations in attributes_for' do
      let(:parent_model) { Fabricate(:parent_data_mapper_model) }
      subject do
        Fabricate.attributes_for(
          :child_data_mapper_model, parent_data_mapper_model: parent_model
        )
      end

      it 'serializes the belongs_to as an id' do
        should include({ parent_data_mapper_model_id: parent_model.id })
      end
    end
  end

  context 'referenced mongoid documents', depends_on: :mongoid do
    let(:fabricator_name) { :parent_mongoid_document }
    let(:collection_field) { :referenced_mongoid_documents }
    it_should_behave_like 'something fabricatable'
  end

  context 'embedded mongoid documents', depends_on: :mongoid do
    let(:fabricator_name) { :parent_mongoid_document }
    let(:collection_field) { :embedded_mongoid_documents }
    it_should_behave_like 'something fabricatable'
  end

  context 'sequel models', depends_on: :sequel do
    let(:fabricator_name) { :parent_sequel_model }
    let(:collection_field) { :child_sequel_models }
    it_should_behave_like 'something fabricatable'

    context 'with class table inheritance' do
      before do
        clear_sequel_db
        Fabricate(:inherited_sequel_model)
        Fabricate(:parent_sequel_model)
        Fabricate(:inherited_sequel_model)
      end

      it 'generates the right number of objects' do
        expect(ParentSequelModel.count).to eq(3)
        expect(InheritedSequelModel.count).to eq(2)
      end
    end
  end

  context 'when the class requires a constructor' do
    before(:all) do
      class CustomInitializer < Struct.new(:field1, :field2); end
      Fabricator(:custom_initializer)
    end

    subject do
      Fabricate(:custom_initializer) do
        on_init { init_with('value1', 'value2') }
      end
    end

    its(:field1)  { should == 'value1' }
    its(:field2) { should == 'value2' }
  end

  context 'with the generation parameter' do
    let(:parent_ruby_object) do
      Fabricate(:parent_ruby_object, string_field: "Paul") do
        placeholder { |attrs| "#{attrs[:string_field]}#{attrs[:number_field]}" }
        number_field 50
      end
    end

    it 'evaluates the fields in order of declaration' do
      expect(parent_ruby_object.string_field).to eq("Paul")
    end
  end

  context 'with a field named the same as an Object method' do
    subject { Fabricate(:predefined_namespaced_class, display: 'working') }
    its(:display) { should == 'working' }
  end

  context 'multiple instance' do
    let!(:parent_ruby_object1) { Fabricate(:parent_ruby_object, string_field: 'Jane') }
    let!(:parent_ruby_object2) { Fabricate(:parent_ruby_object, string_field: 'John') }

    it 'parent_ruby_object1 has the correct string field' do
      expect(parent_ruby_object1.string_field).to eq('Jane')
    end

    it 'parent_ruby_object2 has the correct string field' do
      expect(parent_ruby_object2.string_field).to eq('John')
    end

    it 'they have different extra fields' do
      expect(parent_ruby_object1.extra_fields).to_not equal(parent_ruby_object2.extra_fields)
    end
  end

  context 'with a specified class name' do
    subject { Fabricate(:custom_parent_ruby_object) }

    before do
      Fabricator(:custom_parent_ruby_object, class_name: :parent_ruby_object) do
        string_field 'different'
      end
    end

    its(:string_field) { should == 'different' }
  end

  context 'for namespaced classes' do
    context 'the namespaced class' do
      subject { Fabricate('namespaced_classes/ruby_object', name: 'working') }
      its(:name) { should eq('working') }
      it { should be_a(NamespacedClasses::RubyObject) }
    end

    context 'descendant from namespaced class' do
      subject { Fabricate(:predefined_namespaced_class) }
      its(:name) { should eq('aaa') }
      it { should be_a(NamespacedClasses::RubyObject) }
    end
  end

  context 'with a mongoid document', depends_on: :mongoid do
    it "sets dynamic fields" do
      expect(Fabricate(:parent_mongoid_document, mongoid_dynamic_field: 50).mongoid_dynamic_field).to eq 50
    end

    it "sets lazy dynamic fields" do
      expect(Fabricate(:parent_mongoid_document) { lazy_dynamic_field "foo" }.lazy_dynamic_field).to eq 'foo'
    end

    context "with disabled dynamic fields" do
      it "raises NoMethodError for mongoid_dynamic_field=" do
        if Mongoid.respond_to?(:allow_dynamic_fields=)
          Mongoid.allow_dynamic_fields = false
          expect do
            Fabricate(:parent_mongoid_document, mongoid_dynamic_field: 50)
          end.to raise_error(Mongoid::Errors::UnknownAttribute, /mongoid_dynamic_field=/)
          Mongoid.allow_dynamic_fields = true
        end
      end
    end
  end

  context 'with multiple callbacks' do
    subject { Fabricate(:multiple_callbacks) }
    before(:all) do
      Fabricator(:multiple_callbacks, from: OpenStruct) do
        before_validation { |o| o.callback1 = 'value1' }
        before_validation { |o| o.callback2 = 'value2' }
      end
    end
    its(:callback1) { should == 'value1' }
    its(:callback2) { should == 'value2' }
  end

  context 'with multiple, inherited callbacks' do
    subject { Fabricate(:multiple_inherited_callbacks) }
    before(:all) do
      Fabricator(:multiple_inherited_callbacks, from: :multiple_callbacks) do
        before_validation { |o| o.callback3 = o.callback1 + o.callback2 }
      end
    end
    its(:callback3) { 'value1value2' }
  end

  describe '.clear_definitions' do
    before { Fabrication.clear_definitions }
    subject { Fabrication.manager }
    it { should be_empty }
    after { Fabrication.manager.load_definitions }
  end

  context 'when defining a fabricator twice' do
    it 'throws an error' do
      expect { Fabricator(:parent_ruby_object) {} }.to raise_error(Fabrication::DuplicateFabricatorError)
    end
  end

  context "when fabricating class that doesn't exist" do
    before { Fabricator(:class_that_does_not_exist) }
    it 'throws an error' do
      expect { Fabricate(:class_that_does_not_exist) }.to raise_error(Fabrication::UnfabricatableError)
    end
  end

  context 'when generating from a non-existant fabricator' do
    it 'throws an error' do
      expect { Fabricate(:misspelled_fabricator_name) }.to raise_error(Fabrication::UnknownFabricatorError)
    end
  end

  context 'defining a fabricator' do
    context 'without a block' do
      before(:all) do
        class Widget; end
        Fabricator(:widget)
      end

      it 'works fine' do
        expect(Fabricate(:widget)).to be
      end
    end
  end

  describe "Fabricate with a sequence" do
    subject { Fabricate(:sequencer) }

    its(:simple_iterator) { should == 0 }
    its(:param_iterator)  { should == 10 }
    its(:block_iterator)  { should == "block2" }

    context "when namespaced" do
      subject { Fabricate("Sequencer::Namespaced") }

      its(:iterator) { should == 0 }
    end
  end

  describe 'Fabricating while initializing' do
    before { Fabrication.manager.preinitialize }
    after { Fabrication.manager.freeze }

    it 'throws an error' do
      expect { Fabricate(:your_mom) }.to raise_error(Fabrication::MisplacedFabricateError)
    end
  end

  describe 'using an actual class in options' do
    subject { Fabricate(:actual_class) }

    context 'from' do
      before do
        Fabricator(:actual_class, from: OpenStruct) do
          name 'Hashrocket'
        end
      end
      after { Fabrication.clear_definitions }
      its(:name) { should == 'Hashrocket' }
      it { should be_kind_of(OpenStruct) }
    end

    context 'class_name' do
      before do
        Fabricator(:actual_class, class_name: OpenStruct) do
          name 'Hashrocket'
        end
      end
      after { Fabrication.clear_definitions }
      its(:name) { should == 'Hashrocket' }
      it { should be_kind_of(OpenStruct) }
    end
  end

  describe 'accidentally an infinite recursion' do
    context 'a single self-referencing fabricator' do
      before do
        Fabricator(:infinite_recursor, class_name: :child_ruby_object) do
          parent_ruby_object { Fabricate(:infinite_recursor) }
        end
      end

      it 'throws a meaningful error' do
        expect do
          Fabricate(:infinite_recursor)
        end.to raise_error(
          Fabrication::InfiniteRecursionError,
          'You appear to have infinite recursion with the `infinite_recursor` fabricator'
        )
      end
    end

    context 'a parent-child recursive scenario' do
      before do
        Fabricator(:parent_recursor, class_name: :parent_ruby_object) do
          child_ruby_objects(count: 1, fabricator: :child_recursor)
        end

        Fabricator(:child_recursor, class_name: :child_ruby_object) do
          parent_ruby_object { Fabricate(:parent_recursor) }
        end
      end

      it 'throws a meaningful error' do
        expect do
          Fabricate(:parent_recursor)
        end.to raise_error(
          Fabrication::InfiniteRecursionError,
          'You appear to have infinite recursion with the `parent_recursor` fabricator'
        )
      end
    end
  end

  describe 'using the rand option' do
    before { Fabrication.clear_definitions }

    context 'with an integer' do
      let!(:parent) do
        Fabricate(:parent_ruby_object) do
          child_ruby_objects(rand: 3)
        end
      end

      it 'generates between 1 and 3 child_ruby_objects' do
        expect(parent.child_ruby_objects.length).to be >= 1
        expect(parent.child_ruby_objects.length).to be <= 3
      end
    end

    context 'with a range' do
      let!(:parent) do
        Fabricate(:parent_ruby_object) do
          child_ruby_objects(rand: 3..5)
        end
      end

      it 'generates between 3 and 5 child_ruby_objects' do
        expect(parent.child_ruby_objects.length).to be >= 3
        expect(parent.child_ruby_objects.length).to be <= 5
      end
    end
  end

end
