require_relative 'log'

class Command

  def help
    Log.log("Unexpected base class call (help)", Log::Level::ERROR)
  end

  def run(gitdir, options)
    Log.log("Unexpected base class call (run)", Log::Level::ERROR)
  end

end


