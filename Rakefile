require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

require 'bundler'

Bundler.require(:default, ENV['APP_ENV'] || ENV['RAILS_ENV'] || :development)

$LOAD_PATH << File.expand_path('lib', __dir__)

require 'async_sequel_demo'

Rake.add_rakelib(File.expand_path('lib/tasks', __dir__))
