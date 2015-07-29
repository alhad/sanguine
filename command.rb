


class Command

def help
end

def run
end

end

class CommandList < Command
def initialize(commands)
   @commands = commands
end

def help(cmd)     
end

def run
   raise "Cannot run Commandlist"
end

end


class CheckoutCommand < Command

def help
	"Checkout command"
end

def run
   puts "Running checkout command"
end

end


cc = CheckoutCommand.new
puts cc.help
cc.run