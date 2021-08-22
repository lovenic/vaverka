require 'singleton'

module Index
  class HashMap
    include Singleton

    attr_accessor :offsets

    def self.save_to_disk
      puts "Flusing index to disk"

      Index::HashMap.instance.offsets.each_key do |index_key|
        File.write(index_key, Marshal.dump(Index::HashMap.instance.offsets[index_key]))
      end
    end

    def self.load_from_disk
      Dir.children(Config::DB::DB_NAME)
        .select { |f| File.extname(f) == Config::DB::INDEX_FILE_EXTENSION }
        .map{ |f| File.basename(f, File.extname(f)) }
        .each do |basename|
          filename = Index::HashMap.index_filename(basename: basename)
          data = File.read(filename)
          if Index::HashMap.instance.offsets[filename].nil?
            Index::HashMap.instance.offsets[filename] = Marshal.load(data)
          end
        end
    end

    def self.verify_index_presence
      Dir.children(Config::DB::DB_NAME)
        .select { |f| File.extname(f) == Config::DB::STORAGE_FILE_EXTENSION }
        .each do |file|
          basename = File.basename(file, File.extname(file))
          next if File.exist?(Index::HashMap.index_filename(basename: basename))

          # TODO: execute file creation in separate threads
          Index::HashMap.create_index_for(basename: basename)
        end
    end

    def self.create_index_for(basename:)
      index_filename = Index::HashMap.index_filename(basename: basename)
      storage_filename = Index::HashMap.storage_filename(basename: basename)
      Index::HashMap.instance.offsets[index_filename] = {}
      # add index to memory
      File.open(storage_filename) do |f|
        current_pos = f.pos
        f.each_line do |line|
          key = line.split(",")[0]
          Index::HashMap.instance.offsets[index_filename][key] = current_pos
          current_pos = f.pos
        end
      end
      # flush to file
      FileUtils.touch(index_filename)
      File.write(index_filename, Marshal.dump(Index::HashMap.instance.offsets[index_filename]))
    end

    def self.index_filename(basename:)
      "#{Config::DB::DB_NAME}/#{basename}#{Config::DB::INDEX_FILE_EXTENSION}"
    end

    def self.storage_filename(basename:)
      "#{Config::DB::DB_NAME}/#{basename}#{Config::DB::STORAGE_FILE_EXTENSION}"
    end
  end
end
