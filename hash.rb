require 'digest/sha1'
require_relative 'GitObject'

class GitHash
  def self.hash(gitObject)
    Digest::SHA1.hexdigest(gitObject.getHashContent)
  end
end