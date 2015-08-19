require 'fileutils'
require 'zlib'
require_relative 'GitObject'
require_relative 'hash'

class BlobObject < GitObject
  def initialize(blobContent)
    @blobContent = blobContent
    @blobHeader = "blob #{blobContent.length}\0"
    @sha1 = GitHash.hash(self)
  end

  def getHashContent
    @blobHeader + @blobContent
  end

  def store(gitDir)
    path = GitObject.getPath(gitDir, @sha1)
    FileUtils.mkdir_p(File.dirname(path))
    zipContent = Zlib::Deflate.deflate(getHashContent())
    File.open(path, "w") { |f| f.write zipContent }
  end

attr_reader :sha1
end

if __FILE__ == $0
  bo = BlobObject.new("what is up, doc?")
  bo.store("/tmp/scripttest/.git")
end