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
      Fabricate(fabricator_name).should_not == subject
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
        o.should_not be_persisted
      end
    end
  end

  context 'attributes for' do
    subject { Fabricate.attributes_for(fabricator_name) }
    it { should be_kind_of(HashWithIndifferentAccess) }
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
    subject { Fabricate("#{collection_field.to_s.singularize}_with_parent") }

    it 'sets the parent association' do
      subject.send(fabricator_name).should be
    end

    it 'sets the id of the associated object' do
      subject.send("#{fabricator_name}_id").should == subject.send(fabricator_name).id
    end
  end
end

describe Fabrication do

  context 'plain old ruby objects' do
    let(:fabricator_name) { :parent_ruby_object }
    let(:collection_field) { :child_ruby_objects }
    it_should_behave_like 'something fabricatable'
  end

  context 'active_record models' do
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

  context 'data_mapper models' do
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

  context 'referenced mongoid documents' do
    let(:fabricator_name) { :parent_mongoid_document }
    let(:collection_field) { :referenced_mongoid_documents }
    it_should_behave_like 'something fabricatable'
  end

  context 'embedded mongoid documents' do
    let(:fabricator_name) { :parent_mongoid_document }
    let(:collection_field) { :embedded_mongoid_documents }
    it_should_behave_like 'something fabricatable'
  end

  context 'sequel models' do
    let(:fabricator_name) { :parent_sequel_model }
    let(:collection_field) { :child_sequel_models }
    it_should_behave_like 'something fabricatable'
  end

  context 'keymaker models' do
    let(:fabricator_name) { :parent_keymaker_node }

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
      its(:before_save_value) { should == 11 }
    end

    context 'overriding at fabricate time' do
      let(:fabricated_object) do
        Fabricate(
          fabricator_name,
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
    end

    context 'state of the object' do
      it 'generates a fresh object every time' do
        Fabricate(fabricator_name).should_not == subject
      end
      it { should be_persisted }
    end

    context 'transient attributes' do
      it { should_not respond_to(:placeholder) }
    end

    context 'build' do
      subject { Fabricate.build(fabricator_name) }
      it { should_not be_persisted }
    end

    context 'attributes for' do
      subject { Fabricate.attributes_for(fabricator_name) }
      it { should be_kind_of(HashWithIndifferentAccess) }
      it 'serializes the attributes' do
        should include({
          :dynamic_field => nil,
          :nil_field => nil,
          :number_field => 5,
          :string_field => 'content'
        })
      end
    end
  end

  context 'when the class requires a constructor' do
    subject do
      Fabricate(:city) do
        on_init { init_with('Jacksonville Beach', 'FL') }
      end
    end

    its(:city)  { should == 'Jacksonville Beach' }
    its(:state) { should == 'FL' }
  end

  context 'with a class in a module' do
    subject { Fabricate("Something::Amazing", :stuff => "things") }
    its(:stuff) { should == "things" }
  end

  context 'with the generation parameter' do

    let(:person) do
      Fabricate(:person, :first_name => "Paul") do
        last_name { |attrs| "#{attrs[:first_name]}#{attrs[:age]}" }
        age 50
      end
    end

    it 'evaluates the fields in order of declaration' do
      person.last_name.should == "Paul"
    end

  end

  context 'with a field named the same as an Object method' do
    subject { Fabricate(:company) }
    its(:display) { should == 'for sure' }
  end

  context 'multiple instance' do

    let(:person1) { Fabricate(:person, :first_name => 'Jane') }
    let(:person2) { Fabricate(:person, :first_name => 'John') }

    it 'person1 is named Jane' do
      person1.first_name.should == 'Jane'
    end

    it 'person2 is named John' do
      person2.first_name.should == 'John'
    end

    it 'they have different last names' do
      person1.last_name.should_not == person2.last_name
    end

  end

  context 'with a specified class name' do

    let(:someone) { Fabricate(:someone) }

    before do
      Fabricator(:someone, :class_name => :person) do
        first_name "Paul"
      end
    end

    it 'generates the person as someone' do
      someone.first_name.should == "Paul"
    end

  end

  context 'with an active record object' do

    before { TestMigration.up }
    after  { TestMigration.down }

    before(:all) do
      Fabrication.schematics
      Fabricator(:main_company, :from => :company) do
        name { Faker::Company.name }
        divisions(:count => 4)
        non_field { "hi" }
        after_create { |o| o.update_attributes(city: "Jacksonville Beach") }
      end

      Fabricator(:other_company, :from => :main_company) do
        divisions(:count => 2)
        after_build { |o| o.name = "Crazysauce" }
      end
    end

    let(:company) { Fabricate(:main_company, :name => "Hashrocket") }
    let(:other_company) { Fabricate(:other_company) }

    it 'generates field blocks immediately' do
      company.name.should == "Hashrocket"
    end

    it 'generates associations immediately when forced' do
      Division.find_all_by_company_id(company.id).count.should == 4
    end

    it 'generates non-database backed fields immediately' do
      company.instance_variable_get(:@non_field).should == 'hi'
    end

    it 'executes after build blocks' do
      other_company.name.should == 'Crazysauce'
    end

    it 'executes after create blocks' do
      company.city.should == 'Jacksonville Beach'
    end

    it 'overrides associations' do
      Fabricate(:company, :divisions => []).divisions.should == []
    end

    it 'overrides inherited associations' do
      other_company.divisions.count.should == 2
      Division.count.should == 2
    end

  end

  context 'for namespaced classes' do
    context 'the namespaced class' do
      subject { Fabricate('namespaced/team') }
      its(:name) { should eq('A Random Team') }
      its(:members_count) { should be_nil }
    end

    context 'descendant from namespaced class' do
      subject { Fabricate(:team_with_members_count) }
      its(:name) { should eq('A Random Team') }
      its(:members_count) { should == 7 }
    end
  end

  context 'with a mongoid document' do

    let(:author) { Fabricate(:author) }

    it "sets the author name" do
      author.name.should == "George Orwell"
    end

    it 'generates four books' do
      author.books.map(&:title).should == (1..4).map { |i| "book title #{i}" }
    end

    it "sets dynamic fields" do
      Fabricate(:special_author).mongoid_dynamic_field.should == 50
    end

    it "sets lazy dynamic fields" do
      Fabricate(:special_author).lazy_dynamic_field.should == "foo"
    end

    context "with disabled dynamic fields" do
      before { Mongoid.allow_dynamic_fields = false }
      after { Mongoid.allow_dynamic_fields = true }

      it "raises NoMethodError for mongoid_dynamic_field=" do
        expect { Fabricate(:special_author) }.to raise_error(Mongoid::Errors::UnknownAttribute, /mongoid_dynamic_field=/)
      end
    end
  end

  context 'with multiple callbacks' do
    let(:child) { Fabricate(:child) }

    it "runs the first callback" do
      child.first_name.should == "Johnny"
    end

    it "runs the second callback" do
      child.age.should == 10
    end
  end

  context 'with multiple, inherited callbacks' do
    let(:senior) { Fabricate(:senior) }

    it "runs the parent callbacks first" do
      senior.age.should == 70
    end
  end

  context 'with a parent fabricator' do

    context 'and a previously defined parent' do

      let(:ernie) { Fabricate(:hemingway) }

      it 'has the values from the parent' do
        ernie.books.count.should == 4
      end

      it 'overrides specified values from the parent' do
        ernie.name.should == 'Ernest Hemingway'
      end

    end

    context 'and a class name as a parent' do

      let(:greyhound) { Fabricate(:greyhound) }

      it 'has the breed defined' do
        greyhound.breed.should == 'greyhound'
      end

      it 'does not have a name' do
        greyhound.name.should be_nil
      end

    end

  end

  describe '.clear_definitions' do
    before { Fabrication.clear_definitions }
    after { Fabrication::Support.find_definitions }

    it 'should not generate authors' do
      Fabrication.schematics[:author].should be_nil
    end
  end

  context 'when defining a fabricator twice' do
    it 'throws an error' do
      lambda { Fabricator(:author) {} }.should raise_error(Fabrication::DuplicateFabricatorError)
    end
  end

  context "when defining a fabricator for a class that doesn't exist" do
    it 'throws an error' do
      lambda { Fabricator(:your_mom) }.should raise_error(Fabrication::UnfabricatableError)
    end
  end

  context 'when generating from a non-existant fabricator' do
    it 'throws an error' do
      lambda { Fabricate(:your_mom) }.should raise_error(Fabrication::UnknownFabricatorError)
    end
  end

  context 'defining a fabricator' do
    context 'without a block' do
      before(:all) do
        class Widget; end
        Fabricator(:widget)
      end

      it 'works fine' do
        Fabricate(:widget).should be
      end
    end

    context 'for a non-existant class' do
      it "raises an error if the class cannot be located" do
        lambda { Fabricator(:somenonexistantclass) }.should raise_error(Fabrication::UnfabricatableError)
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
    before { Fabrication.schematics.preinitialize }
    after { Fabrication.schematics.freeze }

    it 'throws an error' do
      lambda { Fabricate(:your_mom) }.should raise_error(Fabrication::MisplacedFabricateError)
    end
  end

end
