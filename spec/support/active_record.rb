require 'active_record'

dbconfig = {
  :adapter => 'sqlite3',
  :database => ':memory:'
}

ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Migration.verbose = false

class TestMigration < ActiveRecord::Migration
  def self.up
    create_table :companies, :force => true do |t|
      t.column :name, :string
      t.column :city, :string
    end

    create_table :divisions, :force => true do |t|
      t.column :name, :string
      t.references :company
    end
  end

  def self.down
    drop_table :companies
    drop_table :divisions
  end
end

class Company < ActiveRecord::Base
  has_many :divisions

  attr_accessor :non_field
end

class Division < ActiveRecord::Base
  belongs_to :company
end
