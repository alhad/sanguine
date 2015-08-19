require 'fileutils'
require 'zlib'
require 'ostruct'
require_relative 'GitObject'
require_relative 'hash'
require_relative 'NumberUtils'

class TreeObject < GitObject
  def initialize
    @entries = []
  end

  def getHashContent
    @fileContent
  end

  def create(entries)
    @entries = entries

    sizeField = 0

    @entries.each do |entry|
      sizeField = sizeField + entry.unixpermissions.to_s.size + 1 + entry.name.size + 1 + entry.sha1.size
    end

    puts "Size passed in is #{sizeField}"

    @fileContent = "tree #{sizeField}\0"

    @entries.each do |entry|
      @fileContent = @fileContent + entry.unixpermissions.to_s + " " + entry.name + "\0" + entry.sha1
    end


    hash = GitHash.hash(self)
    @fileContent += "\n"
    File.open("/tmp/tree2", "wb") do |f|
      f.write @fileContent
    end


    puts "Calculated hash as #{hash}"
  end

  def store(gitDir)
  end

  def read(objectBuf)
    treeContent = Zlib::Inflate.inflate(objectBuf)
    File.open("/tmp/tree", "wb") do |f|
      f.write treeContent
    end
    if treeContent[0..3] != "tree"
      Log.log("Illegal tree object")
      return false
    end

    i = 5
    j = 0
    while !NumberUtils.nullChar?(treeContent, i+j)
      j = j + 1
    end

    @contentSize = treeContent[i, i+j].to_i
    puts "Read contentsize as #{@contentSize}"

    iter = i+j+1

    while iter < treeContent.size
      entry = OpenStruct.new
      j = 0
      while treeContent[iter + j] != ' '
        j = j + 1
      end
      entry[:unixpermissions] = treeContent[iter..iter+j].to_i

      iter = iter + j + 1

      entry[:name] = NumberUtils.readString(treeContent, iter)

      iter = iter + entry.name.size + 1
      entry[:sha1] = NumberUtils.readsha1nounpack(treeContent, iter)
      sha1string = NumberUtils.readsha1(treeContent, iter)

      # SHA1 is 20 bytes on disk when represented as a number
      iter = iter + entry.sha1.size

      @entries << entry
    end
    @entries
  end

end

if __FILE__ == $0
  objectContent = IO.binread(".git/objects/3f/04f7805efc6d053e8bb7674e622e9b14c70265")
  to = TreeObject.new
  entries = to.read(objectContent)
  to.create(entries)
end