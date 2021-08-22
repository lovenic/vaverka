module CLI
  module Commands
    class Insert < Dry::CLI::Command
      desc 'Insert a row to the DB'

      argument :key, desc: "Inserting key"
      argument :value, desc: "Inserting value"

      def call(key: nil, value: nil, **)
        uri = URI("http://localhost:#{Config::Server::PORT}/insert?key=#{key}&value=#{value}")
        puts Net::HTTP.get(uri)
      end
    end
  end
end
