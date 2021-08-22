require "dry/cli"
require "cli/commands/init"
require "cli/commands/version"
require "cli/commands/get"
require "cli/commands/insert"
require "cli/commands/init"
require "cli/commands/start"

module CLI
  module Commands
    extend Dry::CLI::Registry

    register "version", Version, aliases: ["v", "-v", "--version"]
    register "insert",  Insert
    register "get",     Get
    register "init",    Init
    register "start",   Start
  end
end

