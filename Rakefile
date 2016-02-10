require 'rspec/core/rake_task'
require 'dotenv/tasks'

desc 'run tests'
RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/api/*_spec.rb']
end

desc 'Run Sinatra'
task :serve do
  sh "rerun 'ruby app.rb' --pattern '**/*.{rb,js,coffee,css,scss,sass,erb,html,haml,ru,yml,slim,md,jbuilder}'"
end

task :specs => :dotenv
task :default => :specs
