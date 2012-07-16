module Fabrication
  module Config
    extend self

    def configure
      yield self
    end

    def fabricator_path
      OPTIONS[:fabricator_path]
    end
    alias fabricator_dir fabricator_path

    def fabricator_path=(folders)
      OPTIONS[:fabricator_path] = (Array.new << folders).flatten
    end
    alias fabricator_dir= fabricator_path=

    def path_prefix
      OPTIONS[:path_prefix]
    end

    def path_prefix=(prefix)
      OPTIONS[:path_prefix] = prefix
    end

    def reset_defaults
      OPTIONS.replace(DEFAULTS)
    end

    def active_support?
      @active_support ||= defined?(ActiveSupport)
    end

    def register_with_steps?
      OPTIONS[:register_with_steps]
    end

    def register_with_steps=(register)
      OPTIONS[:register_with_steps] = register
    end

    private

    DEFAULTS = {
      fabricator_path: ['test/fabricators', 'spec/fabricators'],
      register_with_steps: false,
      path_prefix: defined?(Rails) ? Rails.root : "."
    }
    OPTIONS = {}.merge!(DEFAULTS)
  end
end
