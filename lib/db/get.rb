module DB
  class Get
    def self.call(key:)
      index_offset = Index::HashMap.instance.offsets[key]

      if index_offset.nil?
        puts 'Index not found :('

        value = nil

        File.foreach(Config::DB::FILE_PATH) do |line|
          if line.include?(key)
            value = line.split(',')[1]
          end
        end

        if value
          return value
        else
          puts 'Nothing found!'
        end
      else
        puts "Using index... #{index_offset}"
        File.open(Config::DB::FILE_PATH, 'r') do |f|
          f.seek(index_offset)
          return f.readline.split(',')[1]
        end
      end
    end
  end
end
