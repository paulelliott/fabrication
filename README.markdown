### Fabrication ###

Fabrication is an object generation library. It allows you to define Fabricators that are essentially the schematic for objects you want to generate. You can then generate them as needed anywhere in your app or specs.

Currently supported object types are...

* Plain old Ruby objects
* ActiveRecord objects
* Mongoid Documents
* Sequel Models

By default it will lazily generate active record associations. So if you have a has_many :widgets defined, it will not actually generate the widgets until the association is accessed. You can override this by appending "!" to the name of the parameter when defining the field in the Fabricator.

### Important Thing To Note! ###

If you are fabricating an activerecord backed object and it has attributes that are not columns in the underlying table, Fabrication will lazily generate them even if they are not defined associations. You can easily work around this by adding a "!" to the end of the attribute definition in the Fabricator.

    Fabricator(:user) do
      some_delegated_something_or_other! { Fabricate(:something) }
    end

### Installation ###

Add this to your gemfile.

`gem 'fabrication'`

Now you can define fabricators in any of the following locations.

* `spec/fabricators.rb`
* `spec/fabricators/*.rb`

* `test/fabricators.rb`
* `test/fabricators/*.rb`

They are automatically loaded, so no additional requires are necessary.

### Rails 3 Generators ###

They are really easy to configure! Just add this to your `config/application.rb`:

    config.generators do |g|
      g.test_framework      :rspec, :fixture => true
      g.fixture_replacement :fabrication, :dir => "spec/fabricators"
    end

### Cucumber Steps ###

Packaged with the gem is a generator which will load some handy cucumber table steps into your step_definitions folder. You can get them by running `rails g fabrication:cucumber_steps`.

To generating a single "widget" object (expecting a Fabricator(:widget) to be defined):

    Given the following widget:
      | name  | widget_1 |
      | color | red      |

To generate multiple "widget" objects:

    Given the following widgets:
      | name     | color |
      | widget_1 | red   |
      | widget_2 | blue  |
      ...

To generate "wockets" nested within "widget" objects:

    And that widget has the following wocket:
      | title    | Amazing |
      | category | fancy   |

That will use the most recently defined "widget" and pass it into the Fabricator. That obviously requires your "wocket" to have a setter for a "widget".

### Usage ###

Define your fabricators.

    Fabricator(:company) do
      name "Fun Factory"
      employees(:count => 20) { |company, i| Fabricate(:drone, :company => company, :name => "Drone #{i}") }
      location!
      after_build { |company| company.name = "Another #{company.name}" }
      after_create { |company| company.update_attribute(:ceo, Fabricate(:drone, :name => 'Lead Drone') }
    end

Breaking down the above, we are defining a "company" fabricator, which will generate Company model objects.

* The object has a name field, which is statically filled with "Fun Factory".
* It has a has_many association to employees and will generate an array of 20 records as indicated by the :count => 20. The block is passed the company object being fabricated and index of the array being created.
* It has a belongs_to association to location and this will be generated immediately with the company object. This is because of the "!" after the association name. Also, leaving off the block will cause "{ Fabricate(:location) }" to be automatically generated for you. It will singularize the name of the attribute (if String#singularize is present) and use that as the fabricator name.
* After the object is built but before it is saved, it will update the name to "Another Fun Factory".
* After the object is created, it will update the "ceo" association with a new "drone" record.


For a class with required arguments in its constructor, use the `on_init` method:

    Fabricator(:location) do
      on_init { init_with(30.284167, -81.396111) }
    end


### Inheritance ###

So you already have a company fabricator, but you need one that specifically generates an LLC. No problem!

    Fabricator(:llc, :from => :company) do
      type "LLC"
    end

Setting the :from option will inherit the class and all the attributes from the named Fabricator.

You can also explicitly specify the class being fabricated with the :class_name parameter.

    Fabricator(:llc, :class_name => :company) do
      type "LLC"
    end

The callbacks will be stacked when inheriting from other fabricators. For example, when you define something like this:

    Fabricator(:user) do
      after_create { |user| user.confirm! }
    end

    Fabricator(:admin, :from => :user) do
      after_create { |user| user.make_admin! }
    end

When calling `Fabricate(:admin)`, the user callback will be executed first and then the admin callback.

### Fabricating ###

Now that your Fabricators are defined, you can start generating some objects! To generate the LLC from the previous example, just do this:

    llc = Fabricate(:llc, :name => "Awesome Labs", :location => "Earth")

That will return an instance of the LLC using the fields defined in the Fabricators and overriding with anything passed into Fabricate.

If you need to do something more complex, you can also pass a block to Fabricate. You can use all the features available to you when defining Fabricators, but they only apply to the object generated by this Fabricate call.

    llc = Fabricate(:llc, :name => "Awesome, Inc.") do
      location!(:count => 2) { Faker::Address.city }
    end

Sometimes you don't actually need to save an option when it is created but just build it. In that case, just call `Fabricate.build` and it will skip the saving step.

    Fabricate.build(:company, :name => "Hashrocket")

You can also fabricate the object as an attribute hash instead of an actual instance. This is useful for controller or API testing where the receiver wants a hash representation of the object. If you have activesupport it will be a HashWithIndifferentAccess, otherwise it will be a regular Ruby Hash.

    Fabricate.attributes_for(:company)

### Sequences ###

Sometimes you need a sequence of numbers while you're generating data. Fabrication provides you with an easy and flexible means for keeping track of sequences.

This will create a sequence named ":number" that will start at 0. Every time you call it, it will increment by one.

    Fabricate.sequence(:number)

If you need to override the starting number, you can do it with a second parameter. It will always return the seed number on the first call and it will be ignored with subsequent calls.

    Fabricate.sequence(:number, 99)

If you are generating something like an email address, you can pass it a block and the block response will be returned.

    Fabricate.sequence(:name) { |i| "Name #{i}" }

And in a semi-real use case, it would look something like this:

    Fabricate(:person) do
      ssn { Fabricate.sequence :ssn, 111111111 }
      email { Fabricate.sequence(:email) { |i| "user#{i}@example.com" } }
    end

### Contributing ###

I (paulelliott) am actively maintaining this project. If you would like to contribute, please fork the project, make your changes on a feature branch, and submit a pull request.

To run rake successfully:

1. Clone the project
2. Install mongodb and sqlite3 (brew install ...)
3. Install bundler (gem install bundler)
4. Run `bundle install` from the project root
5. Run `rake` and the test suite should be all green!

### Contributors ###

* Les Hill (leshill)
* Jim Remsik (bigtiger)
* Dave Ott (daveott)
* Matt (winescout)
* Lar Van Der Jagt (supaspoida)
* Sandro Turriate (sandro)
* Justin Smestad (jsmestad)
* Christopher Hanks (chanks) - Chained callbacks
* monsterlabs - Rails 3 Generators
* Brandon Weiss (brandonweiss) - Sequal Model support
* Tim Pope (tpope) - Singularize generated fabricator names
