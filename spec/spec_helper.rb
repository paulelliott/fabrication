require 'bundler/setup'

Bundler.require

DEFINED_CLASSES = {
  data_mapper: defined?(DataMapper),
  mongoid: defined?(Mongoid),
  sequel: defined?(Sequel)
}

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

if defined?(I18n)
  I18n.enforce_available_locales = false
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.around do |example|
    example.run if DEFINED_CLASSES.fetch(example.metadata[:depends_on], true)
  end

  config.before(:each) do
    TestMigration.up
    clear_mongodb
  end
end
