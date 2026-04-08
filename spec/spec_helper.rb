# frozen_string_literal: true

require 'eac_rest'
require 'eac_ruby_gem_support'
EacRubyUtils::Rspec.default_setup_create(File.expand_path('..', __dir__))
EacRubyUtils.require_sub __FILE__
