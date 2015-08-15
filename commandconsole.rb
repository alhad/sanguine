require_relative 'command'
require_relative 'git_add'
require_relative 'git_bisect'
require_relative 'git_branch'
require_relative 'git_checkout'
require_relative 'git_clone'
require_relative 'git_commit'
require_relative 'git_diff'
require_relative 'git_fetch'
require_relative 'git_grep'
require_relative 'git_help'
require_relative 'git_init'
require_relative 'git_log'
require_relative 'git_merge'
require_relative 'git_mv'
require_relative 'git_pull'
require_relative 'git_push'
require_relative 'git_rebase'
require_relative 'git_reset'
require_relative 'git_rm'
require_relative 'git_show'
require_relative 'git_status'
require_relative 'git_tag'
  

class CommandConsole
  def initialize
    @commands = {
      "add" => AddCommand,
      "bisect" => BisectCommand,
      "branch" => BranchCommand,
      "checkout" => CheckoutCommand,
      "clone" => CloneCommand,
      "commit" => CommitCommand,
      "diff" => DiffCommand,
      "fetch" => FetchCommand,
      "grep" => GrepCommand,
      "help" => HelpCommand,
      "init" => InitCommand,
      "log" => LogCommand,
      "merge" => MergeCommand,
      "mv" => MvCommand,
      "pull" => PullCommand,
      "push" => PushCommand,
      "rebase" => RebaseCommand,
      "reset" => ResetCommand,
      "rm" => RmCommand,
      "show" => ShowCommand,
      "status" => StatusCommand,
      "tag" => TagCommand,
    }
  end

  def run(command, gitdir, options)
    if !@commands[command]
      puts "sgit: #{command} is not a git command. See 'sgit --help'."
      return
    end
    @commands[command].new.run(gitdir, options)
  end
end
