require 'rake/testtask'
require 'wilbur/version'

namespace :gem do
  require 'bundler/gem_tasks'
end

namespace :test do
  Rake::TestTask.new(:end_to_end) do |t|
    t.verbose = true
    t.libs << "lib"
    t.libs << "test"
    t.test_files = FileList["test/end_to_end/**/*_test.rb"]
    #t.ruby_opts = ["-w"]
  end
end
