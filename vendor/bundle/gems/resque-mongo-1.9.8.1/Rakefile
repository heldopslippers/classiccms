load 'tasks/redis.rake'

$LOAD_PATH.unshift 'lib'
require 'resque/tasks'

def command?(command)
  system("type #{command} > /dev/null 2>&1")
end


#
# Tests
#

task :default => :test

desc "Run tests"
task :test do
  # Don't use the rake/testtask because it loads a new
  # Ruby interpreter - we want to run tests with the current
  # `rake` so our library manager still works
  Dir['test/*_test.rb'].each do |f|
    require f
  end
end

desc "Activate kicker - gem install kicker"
task :kick do
  exec "kicker -e rake lib test"
end


#
# Install
#

task :install => [ 'redis:install', 'dtach:install' ]


#
# Documentation
#

begin
  require 'sdoc_helpers'
rescue LoadError
end

desc "Push a new version to Gemcutter"
task :publish do
  require 'resque/version'

  sh "gem build resque.gemspec"
  sh "gem push resque-#{Resque::Version}.gem"
  sh "git tag v#{Resque::Version}"
  sh "git push origin v#{Resque::Version}"
  sh "git push origin master"
  sh "git clean -fd"
  exec "rake pages"
end
