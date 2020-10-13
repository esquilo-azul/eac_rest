# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRest
  class Entity
    enable_simple_cache
    common_constructor :instance, :data
  end
end
