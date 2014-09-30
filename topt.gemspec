# -*- encoding: utf-8 -*-
require File.expand_path('../lib/topt/version', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'fakeweb', '~> 1.3'
  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'rdoc', '~> 3.9'
  s.add_development_dependency 'rspec', '~> 2.3'
  s.add_development_dependency 'simplecov', '~> 0.4'
  s.authors = ['Yehuda Katz', 'José Valim', 'Martin Emde']
  s.description = %q{Thor compatible command line option parser. A replacement for Ruby's OptionParser (optparse).}
  s.summary = <<-SUMMARY
A replacement for OptionParser ('optparse') and Thor that supports extended options parsing based on Thor's parsing rules.
The goal of topt is a drop in replacement for Thor command line parsing where backwards compatibility is important.
  SUMMARY
  s.email = 'me@martinemde.com'
  s.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.extra_rdoc_files = ['LICENSE.md', 'README.md']
  s.license = 'MIT'
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/martinemde/topt'
  s.name = 'topt'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Topt::VERSION
end
