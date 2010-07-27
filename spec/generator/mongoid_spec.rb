require 'spec_helper'

describe Fabrication::Generator::Mongoid do

  before(:all) do
    Fabricator(:book) { title "book title" }
  end

  let(:schematic) do
    Fabrication::Schematic.new do
      name 'Name'
      handle { |author| author.name.downcase }
      books(:count => 3) { |author, index| Fabricate(:book, :title => "#{author.name} #{index}", :author => author) }
    end
  end

  let(:generator) { Fabrication::Generator::Mongoid.new(Author, schematic) }

  context 'mongoid object' do

    before { generator.generate({:save => true}, :name => 'Something') }

    it 'passes the object to blocks' do
      generator.generate.handle.should == "name"
    end

    it 'passes the object and count to blocks' do
      generator.generate.books.map(&:title).should == ["Name 1","Name 2","Name 3"]
    end

    it 'persists the author upon creation' do
      Author.where(:name => 'Something').first.should be
    end

  end

end
