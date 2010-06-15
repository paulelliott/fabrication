require 'spec_helper'

describe Fabrication::Fabricator do

  it 'generates a new object every time' do
    f = Fabrication::Fabricator.new(:person) { first_name '1' }
    f.fabricate.should_not == f.fabricate
  end

  context 'with a plain old ruby object' do

    let(:fabricator) { Fabrication::Fabricator.new(:person) { first_name '1' } }

    it 'fabricates a Person instance' do
      fabricator.fabricate.instance_of?(Person).should be_true
    end

    it 'uses the base generator' do
      fabricator.instance_variable_get(:@fabricator).instance_of?(Fabrication::Generator::Base).should be_true
    end

  end

  # context 'with an activerecord object' do

    # let(:fabricator) { Fabrication::Fabricator.new(:company) { name '1' } }

    # it 'fabricates a Company instance' do
      # fabricator.fabricate.instance_of?(Company).should be_true
    # end

    # it 'uses the activerecord generator' do
      # fabricator.instance_variable_get(:@fabricator).instance_of?(Fabrication::Generator::ActiveRecord).should be_true
    # end

  # end

end
