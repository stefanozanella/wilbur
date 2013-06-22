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

    filesystem {
      file  'Gemfile'
      file  'Vagrantfile'
      file  'openwrt_release'
      dir   'layouts' do
        file  'layouts.yml'
        dir   'default' do
          file  'dot_config'
        end
      end
      dir   'provisioning' do
        dir   'manifests' do
          file  'builder.pp'
          file  'provisioner.pp'
        end
        dir   'scripts' do
          file  'openwrt_release.sh'
        end
      end
    }.must_exist_within(@working_dir)
  end
end
