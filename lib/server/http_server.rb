require 'socket'

module Server
  class HttpServer

    ACTION_MAPPING = {
      'get' => DB::Get,
      'insert' => DB::Insert
    }.freeze

    def self.start
      server = TCPServer.new Config::Server::PORT
      puts "Server started on #{Config::Server::PORT} port!"
      Index::HashMap.load_from_disk

      loop do
        Thread.start(server.accept) do |client|
          data = client.gets
          http_data = data.split[1]
          action = http_data.match(/\/\w+\?/).to_s[1..-2]
          query = data.split('?')[1].split[0]
          params = URI::decode_www_form(query).to_h.transform_keys(&:to_sym)

          response = ACTION_MAPPING[action].call(**params)

          Server::HttpServer.respond(client, response)
        end
      end
    end

    def self.respond(client, response)
      client.print "HTTP/1.1 200\r\n" # 1
      client.print "Content-Type: text/html\r\n" # 2
      client.print "\r\n" # 3
      client.puts response
      
      client.close
    end
  end
end
