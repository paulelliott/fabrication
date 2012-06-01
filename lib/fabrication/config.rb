module Fabrication
  module Config
    extend self

    def configure
      yield self
    end

    def fabricator_dir
      OPTIONS[:fabricator_dir]
    end

    def fabricator_dir=(folders)
      OPTIONS[:fabricator_dir] = (Array.new << folders).flatten
    end

    def reset_defaults
      OPTIONS.clear
      OPTIONS.merge!(DEFAULTS)
    end

    def active_support?
      @active_support ||= defined?(ActiveSupport)
    end

    private

    DEFAULTS = {
      :fabricator_dir => ['test/fabricators', 'spec/fabricators']
    }
    OPTIONS = {}.merge!(DEFAULTS)
  end
end
