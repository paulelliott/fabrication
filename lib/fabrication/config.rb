module Fabrication
  class Config < Hash

    def self.fabricator_dir
      OPTIONS[:fabricator_dir]
    end

    def self.fabricator_dir=(folders)
      OPTIONS[:fabricator_dir] = (Array.new << folders).flatten
    end

    private

    OPTIONS = {
      :fabricator_dir => ['test/fabricators', 'spec/fabricators']
    }
  end
end
