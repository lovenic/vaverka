require 'singleton'

module Index
  class HashMap
    include Singleton

    attr_accessor :offsets

    def self.save_to_disk
      File.write("index.ivdb", Marshal.dump(Index::HashMap.instance.offsets))
    end

    def self.load_from_disk
      data = File.read("index.ivdb")
      Index::HashMap.instance.offsets = Marshal.load(data)
    end
  end
end
