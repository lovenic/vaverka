module Config
  module DB
    # TODO: store file path in YML and load here
    # value for connecting from CLI
    DB_NAME = 'my_db'
    STORAGE_FILE_EXTENSION = '.vdb'
    INDEX_FILE_EXTENSION = '.ivdb'
    CHUNK_BYTE_LIMIT = 200
  end
end
