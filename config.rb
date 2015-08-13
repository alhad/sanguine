require_relative('log')

class GitConfig

  attr_reader :keys

  def initialize
    @keys = Hash.new
    @keys["core"] = Hash.new
    coreHash = @keys["core"]
    coreHash["repositoryformatversion"] = 0
    coreHash["filemode"] = true
    coreHash["bare"] = false
    coreHash["logallrefupdates"] = false
    coreHash["ignorecase"] = true
    coreHash["precomposeunicode"] = true
    @configArrValid = false
  end

  def create
    @configArr = []
    @configArr.push("[core]")
    @keys["core"].each do |key, value|
      @configArr.push("\t#{key} = #{value}")
    end
    @configArrValid = true

    @configArr.push("\n")
    @configArr.join("\n")
  end

  def write(configPath, overwrite = false)

    if !@configArrValid
      create
    end

    if File.exists? configPath && !overwrite
      Log.log "Not overwriting config"
      return false
    end   

    File.open(configPath, 'w') do |file|
      file.write(configArr.join("\n"))
    end

    true
  end

  def read(configPath)
    if !File.exists? configPath
      Log.log "Not reading config: File does not exist"
      return false
    end

    configLines = File.readlines(configPath)

    sectionHash = {}

    configLines.each do |line|

      # ignore blank lines
      if /\A\s*\z/.match(line)
        next
      end

      # Check if we are at the beginning of the section
      md = /\[(.+)\]/.match(line)
      if md
        if !@keys[md[1]]
          puts "Creating hash"
          @keys[md[1]] = Hash.new
        end
        sectionHash = @keys[md[1]]
        next
      end

      # otherwise parse key value pairs
      md = /\A\s+(\w+)\s*=\s*(\d+|\w+)/.match(line)
      next if !md

      sectionHash[md[1]] = md[2]

    end

    true
  end

end

if __FILE__ == $0
  gc = GitConfig.new
  gc.read("config")

  gc2 = GitConfig.new
  gc2.create
  gc2.write("config2")
end
