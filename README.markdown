### Fabrication ###

Fabrication is an object generation library. It allows you to define Fabricators that are essentially the schematic for objects you want to generate. You can then generate them as needed anywhere in your app or specs.

Currently supported object types are...

* Plain old Ruby objects
* ActiveRecord objects
* Mongoid Documents

By default it will lazily generate active record associations. So if you have a has_many :widgets defined, it will not actually generate the widgets until the association is accessed. You can override this by passing :force => true when defining the field in the Fabricator.

### Installation ###

Add this to your gemfile.

`gem 'fabrication'`

Now you can define fabricators in any of the following locations.

* `spec/fabricators.rb`
* `spec/fabricators/*.rb`

* `test/fabricators.rb`
* `test/fabricators/*.rb`

They are automatically loaded, so no additional requires are necessary.

### Usage ###

Define your fabricators.

    Fabricator(:company) do
      name "Fun Factory"
      employees(:count => 20) { |company, i| Fabricate(:drone, :company => company, :name => "Drone #{i}") }
      location(:force => true) { Fabricate(:location) }
      after_create { |company| company.update_attribute(:ceo, Fabricate(:drone, :name => 'Lead Drone') }
    end

Breaking down the above, we are defining a "company" fabricator, which will generate Company model objects.

* The object has a name field, which is statically filled with "Fun Factory".
* It has a has_many association to employees and will generate an array of 20 records as indicated by the :count => 20. The block is passed the company object being fabricated and index of the array being created.
* It has a belongs_to association to location and this will be generated immediately with the company object. This is because of the :force => true parameter being passed in.
* After the object is created, it will update the "ceo" association with a new "drone" record.

### Inheritance ###

So you already have a company fabricator, but you need one that specifically generates an LLC. No problem!

    Fabricator(:llc, :from => :company) do
      type "LLC"
    end

Setting the :from option will inherit the class and all the attributes from the named Fabricator.
