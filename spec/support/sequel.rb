require 'sequel'

DB = Sequel.sqlite # in memory

class Artist < Sequel::Model
  one_to_many :albums

  attr_accessor :non_field
end

class Album < Sequel::Model
  many_to_one :artist
end
