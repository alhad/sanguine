require_relative 'NumberUtils'

class IndexFlags

  def to_s
    str = "\n"
    if @assumeValid
      str = str + "assume_valid: True\n"
    else
      str = str + "assume_valid: False\n"
    end
    if @extended
      str = str + "extended: True\n"
    else
      str = str + "extended: False\n"
    end
    str = str + "stage: #{@stage}\n"
    str = str + "name length: #{@nameLength}"

    str
  end

  attr_accessor :assumeValid, :extended, :stage, :nameLength   
end


module FlagMasks
  ASSUME_VALID = 0x8000
  EXTENDED = 0x4000
  STAGE = 0x3000
  NAME_LENGTH = 0x0FFF
end

class IndexEntry

  def readFlags(flags)
    indexFlags = IndexFlags.new
    indexFlags.assumeValid = false
    flags = flags.to_i
    if (flags & FlagMasks::ASSUME_VALID) != 0
      indexFlags.assumeValid = true
    end
    indexFlags.extended = false
    if (flags & FlagMasks::EXTENDED) != 0
      indexFlags.extended = true
    end
    indexFlags.nameLength = flags & FlagMasks::NAME_LENGTH
    indexFlags.stage = (flags & FlagMasks::STAGE) >> 12

    indexFlags
  end

  def parse(entryContent)

    @ctimesecs = NumberUtils.read32BitNumber(entryContent, 0)
    @ctimensecs = NumberUtils.read32BitNumber(entryContent, 4)
    @mtimesecs = NumberUtils.read32BitNumber(entryContent, 8)
    @mtimensecs = NumberUtils.read32BitNumber(entryContent, 12)

    @dev = NumberUtils.read32BitNumber(entryContent, 16)
    @ino = NumberUtils.read32BitNumber(entryContent, 20)

    mode = NumberUtils.read32BitNumberNetworkOrder(entryContent, 24)
    objType = mode >> 28
    if objType == 0b1000
      @objectType = "Regular File"
    elsif objType == 0b1010
      @objectType = "Symbolic Link"
    elsif objType == 0b1110
      @objectType = "GitLink"
    else
      @objectType = "Unknown"
    end 

    @uid = NumberUtils.read32BitNumber(entryContent, 28)
    @gid = NumberUtils.read32BitNumber(entryContent, 32)
    @fileSize = NumberUtils.read32BitNumber(entryContent, 36)
    @sha1 = NumberUtils.readsha1(entryContent, 40)
    flags = NumberUtils.read16BitNumber(entryContent, 60)
    @flags = readFlags(flags)
    @filename = NumberUtils.readString(entryContent, 62)
    @entrySize = 62 + @filename.size + 1
    while NumberUtils.nullChar?(entryContent, @entrySize)
      @entrySize += 1
    end

  end

  def initialize(entryContent)
    parse(entryContent)
  end

  def size
    @entrySize
  end

  def to_s
    %{ 
ctimesecs : #{@ctimesecs}
filesize : #{@fileSize}
filename : #{@filename}
flags : #{@flags}
entrysize : #{@entrySize}
object type : #{@objectType}
uid : #{@uid}
SHA-1 : #{@sha1}
    } 
  end

  attr_accessor :ctimesecs, :ctimensecs, :mtimesecs, :mtimensecs, :dev, :ino, :objectType, :unixPermissions, :uid, :gid, :fileSize, :sha1
  attr_accessor :assumeValid, :extended, :stage, :nameLength, :skipWorkTree, :intentToAdd
end


class IndexObject
  include Enumerable

  def initialize
    @indexEntries = []
  end

  def addIndexEntry(entry)
    @indexEntries.push(entry)
  end

  def each(&block)
    @indexEntries.each(&block)
  end 

  attr_accessor :indexVersion, :numIndexEntries  
end



class GitIndex

  attr_reader :indexObject, :extensions

  def initialize(indexDir)  

    @indexObject = IndexObject.new
    @extensions = []
    @indexPath = indexDir + "/index"

  end

  def readIndex

    @content = IO.binread @indexPath

    if @content[0..3] != "DIRC"
      return false
    end

    @indexObject.indexVersion = NumberUtils.read32BitNumber(@content, 4)
    if @indexObject.indexVersion < 2 || @indexObject.indexVersion > 4
      return false
    end

    puts "Index is at version #{@indexObject.indexVersion}"
    if @indexObject.indexVersion == 4
      puts "Currently index version 4 is not supported"
      return false
    end

    @indexObject.numIndexEntries = NumberUtils.read32BitNumber(@content, 8)
    puts "This index has #{@indexObject.numIndexEntries} entries"  

    entryCounter = 0
    offset = 12
    while entryCounter < @indexObject.numIndexEntries
      entry = IndexEntry.new(@content[offset..-1])
      puts entry
      @indexObject.addIndexEntry(entry)
      entryCounter = entryCounter + 1
      offset = offset + entry.size
    end

    if @content.size > offset
      # Read extensions here
    end
    true
  end

  def addEntry(name, sha1)
  end

  def writeIndex
    File.open(@indexPath, "wb") do |f|
      f.write("DIRC")
    end
  end

end


