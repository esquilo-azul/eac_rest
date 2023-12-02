# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_rest/version'

Gem::Specification.new do |s|
  s.name        = 'eac_rest'
  s.version     = EacRest::VERSION
  s.authors     = ['Eduardo H. Bogoni']
  s.summary     = 'A REST helper for Ruby.'

  s.files = Dir['{lib}/**/*']
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'eac_envs-http', '~> 0.5'
  s.add_dependency 'eac_fs', '~> 0.16'
  s.add_dependency 'eac_ruby_utils', '~> 0.120'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.9'
end
