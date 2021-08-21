require "dry/cli"

module CLI
  module Commands
    extend Dry::CLI::Registry

    class Version < Dry::CLI::Command
      desc "Print version"

      def call(*)
        puts "0.0.1"
      end
    end

    class Insert < Dry::CLI::Command
      desc 'Insert a row to the DB'

      argument :key, desc: "Inserting key"
      argument :value, desc: "Inserting value"

      def call(key: nil, value: nil, **)
        uri = URI("http://localhost:#{Config::Server::PORT}/insert?key=#{key}&value=#{value}")
        puts Net::HTTP.get(uri)
      end
    end

    class Get < Dry::CLI::Command
      desc 'Get value from the db'

      argument :key, desc: "Key of the requested value"

      def call(key: nil, **)
        if key.nil?
          puts 'No key specified!'
        end

        uri = URI("http://localhost:#{Config::Server::PORT}/get?key=#{key}")
        puts Net::HTTP.get(uri)
      end
    end

    class Init < Dry::CLI::Command
      desc 'Initialize a database'

      def call(*)
        if File.exist?(Config::DB::FILE_PATH)
          puts "Database is already initialized."
        else
          FileUtils.touch(Config::DB::FILE_PATH)
          puts "Database #{Config::DB::FILE_PATH} has been successfully initialized!"
        end
      end
    end

    class Start < Dry::CLI::Command
      desc 'Start a database server'

      def call(*)
        Server::HttpServer.start
      end
    end

    register "version", Version, aliases: ["v", "-v", "--version"]
    register "insert",  Insert
    register "get",     Get
    register "init",    Init
    register "start",   Start
  end
end

