module DB
  class Get
    def self.call(key:)
      sorted_index_keys = Index::HashMap.instance.offsets.keys.sort.reverse
      index_offset = nil
      index_file = nil

      sorted_index_keys.each do |index_key|
        if Index::HashMap.instance.offsets[index_key][key]
          index_offset = Index::HashMap.instance.offsets[index_key][key]
          index_file = index_key

          break
        end
      end

      if index_offset
        puts "Using index... #{index_offset} in #{index_file}"
        storage_file = index_file.gsub(Config::DB::INDEX_FILE_EXTENSION, Config::DB::STORAGE_FILE_EXTENSION)

        File.open(storage_file, 'r') do |f|
          f.seek(index_offset)
          return f.readline.split(',')[1]
        end
      else
        value = nil

        Dir
          .children(Config::DB::DB_NAME)
          .select { |f| File.extname(f) == Config::DB::STORAGE_FILE_EXTENSION }
          .sort
          .reverse
          .each do |file|
            File.foreach("#{Config::DB::DB_NAME}/#{file}") do |line|
              if line.include?(key)
                value = line.split(',')[1]
              end
            end
    
            if value
              return value
            else
              'Nothing found!'
            end
          end
      end
    end
  end
end
