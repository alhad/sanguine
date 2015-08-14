require_relative 'command'
require_relative 'git_add'
require_relative 'git_checkout'
require_relative 'git_init'
require_relative 'git_help'
require_relative 'git_status'


class CommandConsole
  def initialize
    @commands = {
      "add" => AddCommand,
      "checkout" => CheckoutCommand,
      "help" => HelpCommand,
      "init" => InitCommand,
      "status" => StatusCommand,
    }
  end

  def run(command, gitdir, options)
    if !@commands[command]
      puts "sgit: #{command} is not a git command. See 'sgit --help'."
      return
    end
    @commands[command].new.run(gitdir, options)
  end
end
