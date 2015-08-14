require_relative 'log'
require_relative 'new'


class Command

  def help
    Log.log("Unexpected base class call (help)", Log::Level::ERROR)
  end

  def run(gitdir, options)
    Log.log("Unexpected base class call (run)", Log::Level::ERROR)
  end

end

class AddCommand < Command

  def initialize
  end

  def help
  end

  def run(gitdir, options)
  end

end


class CheckoutCommand < Command

  def initialize
  end

  def help
    "Checkout command"
  end

  def run(gitdir, options)
     puts "Running checkout command"
  end

end

class HelpCommand < Command

  def initialize
  end

  def help
  end

  def run(gitdir, options)
  end

end

class InitCommand < Command

  def initialize
  end

  def help
  end

  def run(gitdir, options)
    FileUtils.mkdir_p(gitdir)
    NewGit.new("#{gitdir}/.git")
  end

end

class StatusCommand < Command

  def initialize
  end

  def help
  end

  def run(gitdir, options)
  end

end


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
      puts "Unknown command #{command}"
      return
    end
    @commands[command].new.run(gitdir, options)
  end
end

