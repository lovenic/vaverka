module CLI
  module Commands
    class Start < Dry::CLI::Command
      desc 'Start a database server'

      def call(*)
        Server::HttpServer.start
      end
    end
  end
end
