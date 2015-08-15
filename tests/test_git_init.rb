require_relative '../git_init.rb'
require "test/unit"

class TestGitInit < Test::Unit::TestCase
  def test_git_init
    assert_equal(0, 0)
  end

  def test_git_init_bare
    assert_equal(0, 0)
  end

end

class TestInitOptionsReader < Test::Unit::TestCase
  def test_all_enabled
    options = InitOptionsReader::read(["-q", "--bare", "--template=test_template", "--separate-git-dir", "gitsepder", "--shared=group"])

    assert_equal(options.quiet, true)
    assert_equal(options.bare, true)
    assert_equal(options.template, "test_template")
    assert_equal(options.separateGitDir, "gitsepder")
    assert_equal(options.shared, :group)
  end

  def test_none_enabled
    options = InitOptionsReader::read([])

    assert_equal(options.quiet, nil)
    assert_equal(options.bare, nil)
    assert_equal(options.template, nil)
    assert_equal(options.separateGitDir, nil)
    assert_equal(options.shared, nil)
  end

  def test_quiet_enabled
    options = InitOptionsReader::read(["-q"])

    assert_equal(options.quiet, true)
    assert_equal(options.bare, nil)
    assert_equal(options.template, nil)
    assert_equal(options.separateGitDir, nil)
    assert_equal(options.shared, nil)

    options = InitOptionsReader::read(["--quiet"])

    assert_equal(options.quiet, true)
    assert_equal(options.bare, nil)
    assert_equal(options.template, nil)
    assert_equal(options.separateGitDir, nil)
    assert_equal(options.shared, nil)
  end

  def test_bare_enabled
    options = InitOptionsReader::read(["--bare"])

    assert_equal(options.quiet, nil)
    assert_equal(options.bare, true)
    assert_equal(options.template, nil)
    assert_equal(options.separateGitDir, nil)
    assert_equal(options.shared, nil)
  end

  def test_template_enabled
    options = InitOptionsReader::read(["--template=tmpl"])

    assert_equal(options.quiet, nil)
    assert_equal(options.bare, nil)
    assert_equal(options.template, "tmpl")
    assert_equal(options.separateGitDir, nil)
    assert_equal(options.shared, nil)
  end

  def test_separate_git_dir
    options = InitOptionsReader::read(["--separate-git-dir=sepgitdir"])

    assert_equal(options.quiet, nil)
    assert_equal(options.bare, nil)
    assert_equal(options.template, nil)
    assert_equal(options.separateGitDir, "sepgitdir")
    assert_equal(options.shared, nil)
  end

  def test_shared
    options = InitOptionsReader::read(["--shared=group"])

    assert_equal(options.quiet, nil)
    assert_equal(options.bare, nil)
    assert_equal(options.template, nil)
    assert_equal(options.separateGitDir, nil)
    assert_equal(options.shared, :group)
    options = InitOptionsReader::read(["--shared=false"])
    assert_equal(options.shared, :false)
    options = InitOptionsReader::read(["--shared=true"])
    assert_equal(options.shared, :true)
    options = InitOptionsReader::read(["--shared=umask"])
    assert_equal(options.shared, :umask)
    options = InitOptionsReader::read(["--shared=all"])
    assert_equal(options.shared, :all)
    options = InitOptionsReader::read(["--shared=world"])
    assert_equal(options.shared, :world)
    options = InitOptionsReader::read(["--shared=everybody"])
    assert_equal(options.shared, :everybody)
  end
end