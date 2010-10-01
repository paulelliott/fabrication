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
