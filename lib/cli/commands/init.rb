module CLI
  module Commands
    class Init < Dry::CLI::Command
      desc 'Initialize a database'
    
      def call(*)
        # TODO: add support for specifying a name while initing db
        if File.exist?(Config::DB::DB_NAME)
          puts "Database is already initialized."
        else
          FileUtils.mkdir(Config::DB::DB_NAME)
          puts "Database #{Config::DB::DB_NAME} has been successfully initialized!"
        end
      end
    end
  end
end
