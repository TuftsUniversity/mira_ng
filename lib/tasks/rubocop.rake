require 'rubocop/rake_task'

desc 'Run rubocop'
task :rubocop do
  RuboCop::RakeTask.new
end