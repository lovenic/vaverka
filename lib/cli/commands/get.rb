module CLI
  module Commands
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
  end
end

