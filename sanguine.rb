
require 'fileutils'

require_relative 'commandconsole'
require_relative 'command'


class Sanguine

  def initialize(gitdir, args)
    CommandConsole.new.run(args[0], gitdir, args[1..-1])
  end

end