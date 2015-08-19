require_relative 'commandconsole'
require_relative 'command'
require_relative 'singletons'


class Sanguine

  def initialize(gitdir, args)
    Singletons.getInstance().gitDir = gitdir + "/.git"
    CommandConsole.new.run(args[0], gitdir, args[1..-1])
  end

end