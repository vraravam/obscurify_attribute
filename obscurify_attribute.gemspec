# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "obscurify_attribute/version"

Gem::Specification.new do |s|
  s.name        = "obscurify_attribute"
  s.version     = ObscurifyAttribute::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vijay R Aravamudhan"]
  s.email       = ["avijayr@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Obscures all sensitive attributes from showing up in the errors objects for Active Records/Resources}
  s.description = %q{Obscures all sensitive attributes from showing up in the errors objects for Active Records/Resources}
  s.homepage    = "https://github.com/vraravam/obscurify_attribute"

  s.add_dependency "activemodel", "~> 3.1"

  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "mocha"

  # s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]
end
