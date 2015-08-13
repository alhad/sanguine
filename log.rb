
class Log

  module Level
    ERROR = "ERROR"
    FATAL = "FATAL"
    INFO  = "INFO"
    DEBUG = "DEBUG"
  end

  def initialize(logfile)
    @logFile = File.open(logfile, "a")
    @logFile.write("-------------------------------------------\n")
    @logFile.write("Log started at #{Time.now}\n")
    @logFile.write("-------------------------------------------\n\n")   
  end

  @@instance = Log.new("log.txt")

  def write(message, level)
    @logFile.write("{#{level}} #{message}\n")
  end

  def self.log(message, level = Level::INFO)
    @@instance.write(message, level)
  end

  private_class_method :new
end

if __FILE__ == $0
  Log.log("Hello!!")
  Log.log("This is an error message", Log::Level::ERROR)
end
