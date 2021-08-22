module CLI
  module Commands
    class Version < Dry::CLI::Command
      desc "Print version"
    
      def call(*)
        puts "0.0.2"
      end
    end
  end
end

