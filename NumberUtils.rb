class NumberUtils

  def self.read32BitNumber(str, offset)
   str[offset, 4].unpack("N")[0]
  end

  def self.write32BitNumber(number)
   [number].pack("L")
  end

  def self.read16BitNumber(str, offset)
    str[offset, 2].unpack("n")[0]
  end

  def self.readsha1(str, offset)
    str[offset, 20].unpack("H*")[0]
  end

  def self.readsha1nounpack(str, offset)
    str[offset, 20]
  end


  def self.readString(str, offset)
    str[offset..-1].unpack("Z*")[0]
  end

  def self.nullChar?(str, offset)
    str[offset].unpack("C")[0] == 0
  end

  def self.read32BitNumberNetworkOrder(str, offset)
    puts str[offset, 4]
    str[offset, 4].unpack("L")[0]
  end

end
