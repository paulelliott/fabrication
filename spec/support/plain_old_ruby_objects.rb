require 'ostruct'

class Persistable
  def persisted?
    @persisted
  end
  def save!
    @persisted = true
  end
end

class ParentRubyObject < Persistable
  attr_accessor \
    :before_save_value,
    :dynamic_field,
    :nil_field,
    :number_field,
    :string_field,
    :false_field,
    :id,
    :extra_fields
  attr_writer :child_ruby_objects

  def initialize
    self.id = 23
    self.before_save_value = 11
  end

  def save!
    super
    child_ruby_objects.each(&:save!)
  end

  def child_ruby_objects
    @child_ruby_objects ||= []
  end
end

class ChildRubyObject < Persistable
  attr_accessor \
    :parent_ruby_object,
    :parent_ruby_object_id,
    :number_field

  def parent_ruby_object=(parent_ruby_object)
    @parent_ruby_object = parent_ruby_object
    @parent_ruby_object_id = parent_ruby_object.id
  end
end

class Troublemaker
  def raise_exception=(value)
    raise "Troublemaker exception" if value
  end
end

class Dog
  attr_accessor :name, :breed, :locations
end

class Location
  attr_accessor :lat, :lng
end

class Person
  attr_accessor :age, :first_name, :last_name, :shoes, :location
end

class City
  attr_accessor :city, :state

  def initialize(city, state)
    self.city = city
    self.state = state
  end
end

class Address
  attr_accessor :city, :state
end

class Contact
  attr_accessor :name, :address
end

module Something
  class Amazing
    attr_accessor :stuff
  end
end

class Sequencer
  attr_accessor :simple_iterator, :param_iterator, :block_iterator

  class Namespaced
    attr_accessor :iterator
  end
end
