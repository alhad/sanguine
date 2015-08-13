#!/usr/bin/env ruby

require 'fileutils'
require_relative 'new'

class Sanguine

  def initialize(gitdir, args)
    puts args[0]
    if args[0] == "init"
      puts "In here #{gitdir}"
      FileUtils.mkdir_p(gitdir)
      NewGit.new("#{gitdir}/.git")
    end
  end



end


s = Sanguine.new(Dir.pwd, ARGV)
