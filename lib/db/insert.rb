module DB
  class Insert
    def self.call(key: nil, value: nil)
      new.insert(key: key, value: value)
    end

    def insert(key:, value:)
      return unless input_valid?(key: key, value: value)

      payload_to_write = payload(key: key, value: value)
      file_to_write = locate_file(payload: payload_to_write)

      open(file_to_write, 'a') do |f|
        f.seek(0, IO::SEEK_END)

        # save index to memory
        index_to_write = file_to_write.gsub(Config::DB::STORAGE_FILE_EXTENSION, Config::DB::INDEX_FILE_EXTENSION)
        if Index::HashMap.instance.offsets[index_to_write].nil?
          Index::HashMap.instance.offsets[index_to_write] = {}
        end
        Index::HashMap.instance.offsets[index_to_write][key] = f.pos

        f.puts "#{key},#{value}"
      end

      # flush to disk wiht 20% probability
      # NOTE: we won't have a index for some values
      # 'cause we restore it only for absent files
      Index::HashMap.save_to_disk if rand < 0.2

      "Success"
    end

    private

    def input_valid?(key:, value:)
      if key.nil? || value.nil?
        puts "Error: key and value are needed"
        return false
      end

      return true
    end

    def locate_file(payload:)
      files = current_files
      if files.length.zero?
        # create 1.vdb file if none yet exist
        filename = "#{Config::DB::DB_NAME}/1#{Config::DB::STORAGE_FILE_EXTENSION}"
        FileUtils.touch(filename)
        filename
      else
        file = files.sort[-1]
        edge_file = "#{Config::DB::DB_NAME}/#{file}#{Config::DB::STORAGE_FILE_EXTENSION}"
        if allowed_to_write?(file: edge_file, payload: payload)
          # in case there's enough room to not exceed the limit
          edge_file
        else
          # when there's no space -> create new chunk and write there
          incremented_file = (file.to_i + 1).to_s
          filename = "#{Config::DB::DB_NAME}/#{incremented_file}#{Config::DB::STORAGE_FILE_EXTENSION}"
          FileUtils.touch(filename)
          filename
        end
      end
    end

    def current_files
      Dir
        .children("#{Config::DB::DB_NAME}")
        .select { |f| File.extname(f) == Config::DB::STORAGE_FILE_EXTENSION }
        .map{ |f| File.basename(f, File.extname(f)) }
    end

    def allowed_to_write?(file:, payload:)
      File.size(file) + payload_size(payload: payload) <= Config::DB::CHUNK_BYTE_LIMIT
    end

    def payload(key:, value:)
      "#{key},#{value}"
    end

    def payload_size(payload:)
      payload.bytesize
    end
  end
end
