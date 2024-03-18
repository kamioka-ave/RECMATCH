# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/npm'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'
require 'capistrano/scm/git'
# require 'seed-fu/capistrano3'

install_plugin Capistrano::SCM::Git

task :autoscaling do
  require 'capistrano/delayed_job'
  require 'elbas/capistrano'
end
task 'production' => [:autoscaling]
task 'staging' => [:autoscaling]

# before 'deploy:publishing', 'db:seed_fu'

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
