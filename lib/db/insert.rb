module DB
  class Insert
    def self.call(key: nil, value: nil)
      if key.nil? || value.nil?
        puts "Error: key and value are needed"
        return 
      end

      open(Config::DB::FILE_PATH, 'a') do |f|
        f.seek(0, IO::SEEK_END)
        Index::HashMap.instance.offsets[key] = f.pos

        f.puts "#{key},#{value}"
      end

      Index::HashMap.save_to_disk

      "Success"
    end
  end
end
