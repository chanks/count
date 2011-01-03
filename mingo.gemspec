# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mingo/version"

Gem::Specification.new do |s|
  s.name        = "mingo"
  s.version     = Mingo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Hanks"]
  s.email       = ["christopher.m.hanks@gmail.com"]
  s.homepage    = "https://github.com/chanks/mingo"
  s.summary     = %q{A simple A/B testing engine for Rails 3.}
  s.description = %q{A Rails 3 engine for simple A/B testing, with results persisted to MongoDB.}

  s.rubyforge_project = "mingo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("railties", "~> 3.0.0")
  s.add_dependency("mongo", "~> 1.1")

  s.add_development_dependency("bson_ext", "~> 1.1")
  s.add_development_dependency("rspec", "~> 2.3.0")
end
