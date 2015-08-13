require_relative "log"
require_relative "config"

require 'fileutils'

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
          puts "Writing #{@gitDir}/#{fileName}"
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
        puts "Copying assets from #{File.dirname(__FILE__)}/#{content[1]}"
        assetDir.each do |file|
          FileUtils.cp(file, "#{assetDestDir}")
        end
      when "rdir"
        FileUtils::mkdir_p "#{@gitDir}/#{fileName}"
      end

    end
  end

end


class NewGit
  def initialize(dir)

    if File.exists?(dir)
      Log.log("Not clobbering existing #{dir}")
      return
    end

    Dir.mkdir(dir)

    GitDirectory.new(dir).create

    puts "Initialized empty Git repository in #{dir}/"

  end
end

if __FILE__ == $0
  g = NewGit.new("/tmp/scripttest/.git")
end