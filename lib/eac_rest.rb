# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__

module EacRest
end

require 'eac_envs/http'
require 'eac_fs'
