require_relative 'command'

class CheckoutCommand < Command

  def initialize
  end

  def help
    "Checkout command"
  end

  def run(gitdir, options)
     puts "Running checkout command"
  end

end

