
require 'fileutils'
require 'optparse'
require 'ostruct'

require_relative 'command'


class OptionsReader
  def self.read(args)
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: sanguine [options]"

      opts.on("--hard", "Hard") do |v|
        options[:hard] = true
      end

      opts.on("--bare", "Bare") do |v|
        options[:bare] = true
      end

    end.parse!

    options
  end
end


class Sanguine

  def initialize(gitdir, args)
    CommandConsole.new.run(args[0], gitdir, OptionsReader.read(args[1..-1]))
  end

end


s = Sanguine.new(Dir.pwd, ARGV)
