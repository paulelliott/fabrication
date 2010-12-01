### 0.9.3 - The Les/Tim release (12/01/2010) ###

* Fail with an error when Fabricating an object fails validation
* Allow mixed use of strings and symbols for attribute names

### 0.9.2 (11/24/2010) ###

* Bugfix: Overrides should respect defined attribute generation order


### 0.9.1 (11/21/2010) ###

* Bugfix: respect fabricator provided attributes when generating with attributes_for
* Basic support for Sequel
* Refactoring of generator logic
* Singularize generated fabricator names


### 0.9.0 (10/07/2010) ###

* Bugfix: callbacks are copied to the local override (leshill and sandro)
* Support for classes with required arguments in their constructor (leshill
and sandro)


### 0.8.3 (09/30/2010) ###

* Bugfix: Non-association virtual attributes were being generated lazily
* Change generated fabricators to have _fabricator in the name
* Change default folder for generated fabricators to spec/fabricators
* Minor tweaks


### 0.8.2 (09/28/2010) ###

- yanked...

### 0.8.1 (09/14/2010) ###

* Bugfix: UnknownFabricatorError not loaded if it is the first error encountered


### 0.8.0 (09/13/2010) ###

* Stacking callbacks (all defined after_build and after_create callbacks will execute)
* Rails 3 generators


### 0.7.1 (09/12/2010) ###

* Looks for Rails root when searching for Fabricators
* Remove default fabricators. All definitions must be explicit!


### 0.7.0 (09/08/2010) ###

* Abbreviated association syntax
* Bugfix: generating with count of 1
* Reimplement attributes_for for full schematic support


### 0.6.4 (08/23/2010) ###

* Accompany errors with helpful messages


### 0.6.3 (08/18/2010) ###

* Add support for reloading fabricator definitions
* Fix rails 2 console reload! issue
