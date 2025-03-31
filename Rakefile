require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

namespace :rbs do
  task :test do
    sh "ruby -I lib test_sig/test_base64.rb"
  end

  task :annotate do
    require "tmpdir"
    require "pathname"

    Dir.mktmpdir do |tmpdir|
      system("rdoc --ri --output #{tmpdir}/doc --root=. lib")
      system("rbs annotate --no-system --no-gems --no-site --no-home -d #{tmpdir}/doc sig")
    end
  end

  task :confirm do
    puts "Testing if RBS docs are updated with respect to RDoc"
    sh "git diff --exit-code sig/"
  end
end

task :default => :test
