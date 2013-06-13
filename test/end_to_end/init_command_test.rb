require 'test_helper'

describe "wilbur init" do
  before do
    @cwd = Dir.pwd
    @working_dir = Dir.mktmpdir("wilbur")
    FileUtils.cd @working_dir
  end

  after do
    FileUtils.cd @cwd
    FileUtils.rm_rf @working_dir
  end

  it "initializes a Wilbur catalog in the current directory" do
    capture_io { Wilbur::CLI.start %w{ init } }

    assert File.exist?("Gemfile"), "Gemfile is missing"
    assert File.exist?("Vagrantfile"), "Vagrantfile is missing"
    assert File.exist?("openwrt_release"), "openwrt_release is missing"
    assert Dir.exist?("layouts"), "directory layouts is missing"
      assert File.exist?("layouts/layouts.yml"), "layouts.yml is missing"
      assert Dir.exist?("layouts/default"), "directory default is missing"
        assert File.exist?("layouts/default/dot_config"), "dot_config is missing"
    assert Dir.exist?("provisioning"), "provisioning directory is missing"
      assert Dir.exist?("provisioning/manifests"), "manifests directory is missing"
        assert File.exist?("provisioning/manifests/builder.pp"), "builder.pp is missing"
        assert File.exist?("provisioning/manifests/provisioner.pp"), "provisioner.pp is missing"
      assert Dir.exist?("provisioning/scripts"), "scripts directory is missing"
        assert File.exist?("provisioning/scripts/openwrt_release.sh"), "openwrt_release.sh is missing"
  end
end
