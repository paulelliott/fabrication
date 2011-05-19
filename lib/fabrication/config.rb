module Fabrication
  class Config < Hash

    def self.fabricator_dir
      OPTIONS[:fabricator_dir]
    end

    def self.fabricator_dir=(folders)
      OPTIONS[:fabricator_dir] = (Array.new << folders).flatten
    end

    def self.reset_defaults
      OPTIONS.clear
      OPTIONS.merge!(DEFAULTS)
    end

    private

    DEFAULTS = {
      :fabricator_dir => ['test', 'spec']
    }
    OPTIONS = {}.merge!(DEFAULTS)
  end
end
