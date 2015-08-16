class GitObject
  def getHashContent
  end

  def self.getPath(gitDir, sha1)
    "#{gitDir}/objects/#{sha1[0,2]}/#{sha1[2,38]}"
  end
end