require 'spec_helper'

describe Fabrication do

  context 'lazy generation' do

    let(:person) { Fabricate(:person) }

    before(:all) do
      Fabricator(:person) do
        first_name 'Joe'
        last_name { Faker::Name.last_name }
      end
    end

    it 'generates static attribute values immediately' do
      person.instance_variable_get(:@first_name).should == 'Joe'
    end

    it 'does not generate block values immediately' do
      person.instance_variable_get(:@last_name).should be_nil
    end

  end

end
