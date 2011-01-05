require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

task :default => :spec
task :all     => [:spec, :rails]

RSpec::Core::RakeTask.new :spec do |spec|
  spec.pattern = "./spec/{functional,unit}/**/*_spec.rb"
end

RSpec::Core::RakeTask.new :rails do |spec|
  spec.pattern = "./spec/rails/**/*_spec.rb"
end
