require "bundler/gem_tasks"
# require 'rake'
require 'rake/testtask'

# Host or location to copy gem to. At the moment this is only a local copy
# operation
GEM_LOCAL = "/Users/scott/.gems-repository"

# Details of theremote server to upload the gem to
GEM_HOST = "gems.signalvsnoise.com"
GEM_HOST_USER = "root"
SSH_KEY = "#{ENV['HOME']}/.ssh/scott-signalvsnoise.key"

Rake::TestTask.new("test:units") { |test|
  %w{. lib test}.each { |dir| test.libs << dir }
  test.test_files = FileList["test/unit/*_test.rb"].exclude("test/test_helper.rb", "test/vendor")
  test.verbose = false
  # test.warning = true
}

Rake::TestTask.new("test:functionals") { |test|
  %w{. lib test}.each { |dir| test.libs << dir }
  test.test_files = FileList["test/functional/*_test.rb"].exclude("test/test_helper.rb", "test/vendor")
  test.verbose = false
  # test.warning = true
}

task :test => ["test:units", "test:functionals"]

def get_version
  DividendPredictor::VERSION
end

task :upload_local do
  # place the gem in the local repository
  gem_file = "pkg/#{APP_NAME}-#{get_version}.gem"
  system "cp #{gem_file} #{GEM_LOCAL}/gems/"

  # update the gem index
  system "cd #{GEM_LOCAL} && gem generate_index -d ."
end

task :sync_remote do
  system "cd #{GEM_LOCAL} && rsync -auvz -e 'ssh -i #{SSH_KEY}' . #{GEM_HOST_USER}@#{GEM_HOST}:/var/www/gems/"
end

task :publish => [ :test, :build, :upload_local, :sync_remote ]
