require_relative 'index'

class Singletons
  def initialize
    @singletons = {
      GitIndex => nil,
    }
  end

  def get(classObject)
    if !@singletons[classObject]
      @singletons[classObject] = classObject.new(@gitDir)
    end
    return @singletons[classObject]
  end

  attr_accessor :gitDir

  @@instance = Singletons.new

  def self.getInstance()
    @@instance
  end

  def self.getSingleton(classObject)
    return @@instance.get(classObject)
  end

  private_class_method :new
end