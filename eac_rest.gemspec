# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_rest/version'

Gem::Specification.new do |s|
  s.name        = 'eac_rest'
  s.version     = EacRest::VERSION
  s.authors     = ['Eduardo H. Bogoni']
  s.summary     = 'A REST helper for Ruby.'

  s.files = Dir['{lib}/**/*']

  s.add_dependency 'curb', '>= 0.9', '<= 2'
  s.add_dependency 'eac_fs', '~> 0.16'
  s.add_dependency 'eac_ruby_utils', '~> 0.112'
  s.add_dependency 'faraday', '~> 2.7', '>= 2.7.4'

  s.add_development_dependency 'aranha-parsers', '~> 0.15'
  s.add_development_dependency 'eac_docker', '~> 0.5'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5.1'
end
