### 2.20.2 ###

* Fix for applications with a phony ActiveRecord module declared (#312)

### 2.20.1 ###

* Make #klass public so the `rake fabrication:list` works properly (#307)
* Fix a bug preventing default expansions from singularizing when using `rand` option (#309)

### 2.20.0 ###

* Allow passing a range to rand (#292, #308)

Now you can pass a range in as the `rand` option to get a random number of related objects. For example, to get a random number of `wockets` between 5 and 9 you could do this:

```
Fabricate(:widget) do
  wockets(rand: 5..9)
end
```

### 2.19.0 ###

* Raise an error when a Sequel model fails to validate (#306)

This is already how ActiveRecord models work within fabrication. If you are running Sequel and encounter errors after upgrading it is because these models were silently failing either in validation or callbacks. Raising errors in these cases will help you improve reliability of your tests.

### 2.18.0 ###

* Raise an error when fabrication detects a potentially infinite recursive build (#305)

If you've set up fabricators that recursively call each other you may see an error like this:

```
You appear to have infinite recursion with the `user` fabricator
```

Your suite may even have been "working properly" before (one of mine was) but this error is now happening. Good news! You can improve the speed of your test suite AND avoid potential errors with a simple change.

It's likely you have a scenario like this in the fabricator named by the error message.

```
Fabricator(:user) do
  sessions(count: 1)
end

Fabricator(:session) do
  user
end
```

If you change the `user` fabricator to build with a nil inverse relationship all will be well again.

```
Fabricator(:user) do
  sessions(count: 1) { Fabricate.build(:session, user: nil) }
end
```

If you have any problems please email the google group and I'll help get you sorted. (fabricationgem@googlegroups.com)

### 2.17.0 ###

* Revert relationship inverse overrides #270
* Drop support for unmaintained ruby versions (< 2.2)
* Drop support for rails 3.1

### 2.16.3 ###

* Support nil prefix when loading files (for pickle compatibility) (#297)

### 2.16.2 ###

* require railtie only if Rails::Railtie is defined (#296)
* Add explicit test suite support for Rails 5.1 and Mongoid 6
* Fix a deprecation warning in sequel

### 2.16.1 ###

* Remove explicit include of Rake::DSL (#290)

### 2.16.0 ###

* Allow configuration of third-party model generators (#285)

### 2.15.2 ###

* Tweaks to prevent warnings from rspec with `--warnings` flag (#279)

### 2.15.1 ###

* Automatically set fabrication as fixture replacement in rails (#280)

### 2.15.0 ###

* Prevent validation callbacks from being called more than once
* Support for belongs_to association detection in ActiveRecord

### 2.14.1 ###

* `include Rake::DSL` to prevent warnings in rake 0.9 and errors in rake 10 (#256)

### 2.14.0 ###

* Add `Fabricate.attributes_for_times` method.

### 2.13.2 ###

* Ignore errors produced from reading attributes during model generation

### 2.13.1 ###

* Wait to process fabricator definitions until they are actually used

### 2.13.0 ###

* Improved performance by lazily loading classes at fabricate time (#244)
* Fields specified in ActiveRecord model generator will be included in Fabricator

### 2.12.2 ###

* Revert usage of ActiveSupport classify. This was expected to make it class resolution easier in Rails apps but turned out to cause a lot of trouble for some users. Everything is back to normal now.

### 2.12.1 ###

* Constantize class_name as it is supplied in fabricator definition (#238)

### 2.12.0 ###

* Fix typo in rake task
* Leverage ActiveSupport's `classify` if available

### 2.11.3 ###

* Fixed a bug preventing the list rake task from working (#213)

### 2.11.2 ###

* Fixed a bug preventing multiple path_prefixes from being loaded

### 2.11.1 ###

* Update string constantize to handle more edge cases (#209)

### 2.11.0 ###

* Process attributes with static values before ones with dynamic values at fabricate time (#208)

### 2.10.0 ###

* Add `rand` option when generating collections in fabricators (#207)
* Include original exception when catching NameError in fabricators (#206)

### 2.9.8 ###

* Explicitly require rake for compatibility with certain IDE's. (#203, #204)

### 2.9.7 ###

* Support multiple path prefixes for fabricator definitions (#188)

### 2.9.6 ###

* Explicitly require singleton in schematic manager (#198)

### 2.9.5 ###

* Replace `delegate` calls with actual methods (#197)

### 2.9.4 ###

* Improve support for Rails 4 projects using protected attributes (#190)
* Add rake task to list all known fabricators (#187)

### 2.9.3 ###

* Use standard schematic fetch in cucumber step fabricator (#185)

### 2.9.2 ###

* Remove deprecation warning for `Fabricate.attributes_for` (#182)

### 2.9.1 ###

* Fix attributes_for deprecation warning message wording (#181)

### 2.9.0 ###

* Add `Fabricate.build_times` method
* Deprecate `Fabricate.attributes_for` in favor of `Fabricate.to_params`
* Add `Fabricate.to_params` for generating hashes

### 2.8.1 ###

* Allow exceptions during fabricator load to pass through (#174)

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
