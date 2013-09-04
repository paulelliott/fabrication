### 2.8.0 ###

* Add support for multiple generations within a single call (#172)
* Fix module declaration in cucumber step generator (#164)
* Drop keymaker support and Neo4J dev dependency

### 2.7.2 ###

* Do not pass without_protection to AR 3.0.

### 2.7.1 ###

* Accept actual classes for `from` and `class_name` Fabricator options. (#160)

### 2.7.0 ###

* Add support for default values on transients.

### 2.6.5 ###

* Fix bug that could prevent sequel's class table inheritance from working (#152)

### 2.6.4 ###

* Refactor how HashWithIndifferentAccess existance is determined (Fixes #153)

### 2.6.3 ###

* Add preliminary support for Mongoid 4.

### 2.6.2 ###

* Add preliminary support for ActiveRecord 4 models.

### 2.6.1 ###

* Only run validation callbacks when creating. Calling `Fabricate.build` will now only run after_build and the deprecation warning on that callback has been removed.

### 2.6.0 ###

* Use activemodel style callbacks. The old after_build callback is equivalent to the new before_validation. See documentation for a full list.

### 2.5.4 ###

* Make transient attributes available in callbacks (Issue #143)
* Fix build parameters for mongoid 2.x line (Issue #144)

### 2.5.3 ###

* Remove try from Schematic::Manager. Some ruby versions were having issues with this (Issue #141)

### 2.5.2 ###

* Improve error explanation for MisplacedFabricateError

### 2.5.1 ###

* Fix bug where strings used in :from attribute would not resolve correctly

### 2.5.0 ###

* Add support for Keymaker
* Evaluate Fabricator blocks against BasicObject to prevent method collisions (#124)

### 2.4.0 ###

* Improve handling of sequel associations (#123)

### 2.3.0 ###

* Remove handling and deprecation warning for "!" association suffix
* Rely on presence of :count option when building associations (#127)
* Add support for overriding the global sequence default
* Improve build flag handling when generating object graphs (#119)

### 2.2.3 ###

* Allow setting of protected attributes in sequel models

### 2.2.2 ###

* Only build when association is `has_many` or equivalent

### 2.2.1 ###

* Improve ORM support for default fabricators (build instead of create)
* Evenly space generated Fabricator attribute values

### 2.2.0 ###

* Add Rails engine support via the path_prefix config option

### 2.1.0 ###

* Add initialize_with option to Fabricators

### 2.0.3 ###

* Fix accidental dependency on ActiveSupport (extract_options!)

### 2.0.2 ###

* Bypass mass assignment protection for AR and Mongoid (Issue #108)

### 2.0.1 ###

* Fix a bug where empty fabricators that extend each other didn't clone properly

### 2.0.0 ###

!!! THIS MAY BREAK YOUR TESTS !!!

* Remove lazy generation of associations
* Set attributes via mass assignment
* Deprecate "!" option to attribute values
* Pass attributes hash into blocks
* Cascade `Fabricate.build` to associations (#68)
* lots of internal API refactoring
* Support for transient attributes (#99)
* Maintain integrity of association proxies (#28)
* Change fabricator_dir config to fabricator_path
* Record both singular and collection objects in step defs (#97)
* Raise meaningful errors when cucumber steps can't find fabricators (#101)
* Rails generator creates fabricator file correctly for namespaced classes (#47)

Upgrade Guide: http://blog.hashrocket.com/posts/fabrication-2-0-upgrade-guide

### 1.4.1 ###

* Check for nil objects when generating ids for hashes
* Add support for make suffixes

### 1.4.0 ###

* Add DataMapper support (thanks to Matt Beetle!)
* Better class resolution
* Handle mongoid dynamic fields
* Use id fields in attribute hashes

### 1.3.2 ###

* Fixed module declaration for turnip steps generator
* Raise an error when fabricating while initializing

### 1.3.0 ###

* Drop support for ruby 1.8
* Add Fabrication Transforms
* Optional machinist (.make) syntax support
* Add generated turnip steps
* Fabricator aliases

### 1.2.0 ###

* Remove use of ivars in fabrication cucumber steps.
    IMPORTANT: Replace "@whatver" in your custom steps with "fabrications[:whatever]"
* Sequences will now remember and reuse the last block passed in.

### 1.1.0 ###

* Sequences no longer require a name
* Add support for mongoid dynamic fields

### 1.0.1 ###

* Bugfix: Sequel models do not save correctly
* Add database verification cucumber step
* Add :fabricator option for associations

### 1.0.0 ###

* New shorthand syntax for sequences
* Configuration for fabrication directory location
* Fabricator file loading enhancements
* (bugfix) only call after_create when save is performed
* Reworking of fabrication steps (run generate to get the updates)

### 0.9.5 (01/17/2010) ###

* Refactor cucumber step support code
* Add default object construction cucumber step (hakanensari)

NOTE: Be sure to run `rails generate fabrication:cucumber_steps` after upgrading!

### 0.9.4 (12/02/2010) ###

* Bundle cucumber steps with gem (installable via a generator)

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
