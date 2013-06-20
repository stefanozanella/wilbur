require 'test_helper'
require 'pathname'

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

    @working_dir.must_have_filesystem_with structure do
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
    end

  end
end

module MiniTest::Assertions
  def structure(&block)
    ::Wilbur::Test::FileSystemMatcher.new(&block)
  end

  def assert_has_filesystem_with(dir, structure_matcher)
    structure_matcher.root = dir
    assert structure_matcher.match?, structure_matcher.failure_msg
  end
end

module MiniTest::Expectations
  infect_an_assertion :assert_has_filesystem_with, :must_have_filesystem_with, true
end

module Wilbur
  module Test
    # TODO More instructive failure messages
    class FileSystemMatcher

      def initialize(&block)
        @expected_structure = proc { block }
      end

      def root=(root)
        @root = Pathname.new(root)
      end

      def file(file)
        @failures = @failures || ! @actual_structure.include?(@root + Pathname.new(file))
      end

      def dir(dir, &block)
        block = Proc.new {} unless block_given?

        file(@root.join(dir))

        if @root.join(dir).directory?
          @failures = @failures || ! self.class.new(@root.join(dir), &block).match?
        end
      end

      def match?
        @actual_structure = Pathname.glob(@root.join('**/*'))
        instance_eval(&@expected_structure)
        not @failures
      end

      def failure_msg
        @failure_msg ||= "Filesystem structure did not match"
      end

      private

      def failure_msg=(msg)
        @failure_msg = msg
      end
    end
  end
end
