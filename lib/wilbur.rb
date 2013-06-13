require 'pathname'

module Wilbur
  class << self
    # @return [Pathname]
    def root
      @root ||= Pathname.new(File.expand_path('..', File.dirname(__FILE__)))
    end
  end
end
