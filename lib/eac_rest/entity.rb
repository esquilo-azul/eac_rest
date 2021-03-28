# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRest
  class Entity
    enable_simple_cache
    common_constructor :api, :data

    class << self
      def from_array_data(api, array_data, *args)
        array_data.map { |item_data| new(api, item_data, *args) }
      end
    end
  end
end
