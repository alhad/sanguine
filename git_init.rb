require_relative "log"
require_relative "config"
require_relative "command"

require 'fileutils'
require 'optparse'
require 'ostruct'

class GitDirectory

  def initialize(gitDir)

    excludeText = %{
# git ls-files --others --exclude-from=.git/info/exclude
# Lines that start with '#' are comments.
# For a project mostly in C, the following would be a good set of
# exclude patterns (uncomment them if you want to use them):
# *.[oa]
# *~
    }

    @rawAssets = {
      "HEAD" => ["file", "ref: refs/heads/master"],
      "branches" => ["dir"],
      "config" => ["object", GitConfig],
      "description" => ["file", "Unnamed repository; edit this file 'description' to name the repository."],
      "hooks" => ["asset", "assets/hooks"],
      "info" => ["dir"],
      "info/exclude" => ["file", excludeText],
      "objects/info" => ["rdir"],
      "objects/pack" => ["rdir"],
      "refs/heads" => ["rdir"],
      "refs/tags" => ["rdir"]
     }

     @gitDir = gitDir
  end

  def create
    @rawAssets.each do |fileName, content|
      case content[0]
      when "file"
        File.open("#{@gitDir}/#{fileName}", "w") do |file|
          file.write("#{content[1]}\n")
        end
      when "dir"
        Dir.mkdir "#{@gitDir}/#{fileName}"
      when "object"
        File.open("#{@gitDir}/#{fileName}", "w") do |file|
           file.write(content[1].new().create)
         end
      when "asset"
        assetDestDir = "#{@gitDir}/#{fileName}"
        Dir.mkdir assetDestDir
        assetDir = Dir["#{File.dirname(__FILE__)}/#{content[1]}/*"]
        assetDir.each do |file|
          FileUtils.cp(file, "#{assetDestDir}")
        end
      when "rdir"
        FileUtils::mkdir_p "#{@gitDir}/#{fileName}"
      end

    end
  end

end


class InitOptionsReader
  def self.read(args)
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: sgit init [options]"

      opts.on("-q", "--quiet", "Quiet", "Only print error and warning messages; all other output will be suppressed") do |v|
        options[:quiet] = true
      end

      opts.on("--bare", "Bare") do |v|
        options[:bare] = true
      end

      opts.on("--template=template_directory", "Template") do |templateDir|
        options[:template] = templateDir
      end

      opts.on("--separate-git-dir git_dir", "SeparateGitDir") do |gitdir|
        options[:separateGitDir] = gitdir
      end

      opts.on("--shared=[opt]", [:false, :true, :umask, :group, :all, :world, :everybody]) do |opt|
        options[:shared] = opt
      end

    end

    opt_parser.parse!(args)

    puts args
    if args.size > 0
      options[:directory] = args[0]
    end

    options
  end
end


class NewGit
  def initialize(dir, options)

    if !options.bare
      dir = dir + "/.git"
      if File.exists?(dir)
        Log.log("Not clobbering existing #{dir}")
        return
      end

      Dir.mkdir(dir)
    end

    GitDirectory.new(dir).create

    bare = ""

    bare = "bare " if options.bare

    puts "Initialized empty #{bare}Git repository in #{dir}"

  end
end

if __FILE__ == $0
  g = NewGit.new("/tmp/scripttest")
end

class InitCommand < Command

  def initialize
  end

  def help
  end

  def run(gitdir, args)
    options = InitOptionsReader.read(args)
    FileUtils.mkdir_p(gitdir)
    NewGit.new("#{gitdir}", options)
  end

end



