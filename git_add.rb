require_relative 'command'
require_relative 'BlobObject'
require_relative 'singletons'
require_relative 'index'

class AddOptionsReader
  def self.read(args)
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: sgit add [options]"

      opts.on("-v", "--verbose", "Verbose") do |v|
        options[:verbose] = true
      end

      opts.on("-n", "--dry-run", "Dry Run") do |v|
        options[:dryrun] = true
      end

      opts.on("-f", "--force", "Force") do |v|
        options[:force] = true
      end

      opts.on("-i", "--interactive", "Interactive") do |v|
        options[:interactive] = true
      end

      opts.on("-e", "--edit", "Edit") do |v|
        options[:edit] = true
      end

      opts.on("--all", "All") do |v|
        options[:all] = true
      end

      opts.on("--no-all", "No All") do |v|
        options[:all] = false
      end

      opts.on("--ignore-removal", "Ignore Removal") do |v|
        options[:ignoreremoval] = true
      end

      opts.on("--no-ignore-removal", "No Ignore Removal") do |v|
        options[:ignoreremoval] = false
      end

      opts.on("-u", "--update", "Update") do |v|
        options[:update] = true
      end

      opts.on("-N", "--intent-to-add", "Intent to Add") do |v|
        options[:intenttoadd] = true
      end

      opts.on("--refresh", "Refresh") do |v|
        options[:refresh] = true
      end

      opts.on("--ignore-errors", "Ignore Errors") do |v|
        options[:ignoreerrors] = true
      end

      opts.on("--ignore-missing", "Ignore Missing") do |v|
        options[:ignoremissing] = true
      end

    end

    opt_parser.parse!(args)

    if args.size > 0
      if args[0] == "--"
        args.shift
      end
      options[:pathspec] = args[0]
      options[:pathspecified] = true
    else
      options[:pathspecified] = false
    end

    options
  end
end

class AddCommand < Command

  def initialize
  end

  def help
  end

  def run(gitdir, args)
    options = AddOptionsReader.read(args)
    # currently only storing blobs
    fileContent = File.read(options.pathspec)
    blob = BlobObject.new(fileContent)
    blob.store(gitdir + "/.git")
    index = Singletons.getSingleton(GitIndex)
    index.addEntry(options.pathspec, blob.sha1)
  end

end
