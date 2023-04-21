# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRest
  class Entity
    enable_abstract
    enable_simple_cache
    common_constructor :api, :data_or_id

    class << self
      def from_array_data(api, array_data, *args)
        array_data.map { |item_data| new(api, item_data, *args) }
      end
    end

    # @return [Hash]
    def data
      self.data_or_id = data_from_id unless data_or_id_data?
      data_or_id
    end

    # @return [Boolean]
    def data_or_id_data?
      data_or_id.is?(::Hash)
    end

    # @return [Hash]
    def data_from_id
      raise_abstract_method __method__
    end
  end
end
