require 'wilbur'

require 'thor'
require 'pathname'

module Wilbur
  class CLI < Thor
    include Thor::Actions

    class << self
      def source_root
        Wilbur.root.join('catalog_skeleton')
      end
    end

    desc "init", "Initialize a new Wilbur catalog in the current directory"
    def init
      Pathname.glob(self.class.source_root.join('**/*'))
        .select { |path| path.file? }
        .map { |path| path.relative_path_from self.class.source_root }
        .delete_if { |path| path == Pathname.new('README.md') }.each do |path|

        template path
      end
    end
  end
end
