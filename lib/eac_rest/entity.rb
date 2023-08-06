# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRest
  class Entity
    enable_abstract_methods
    enable_simple_cache
    enable_listable
    lists.add_symbol :option, :parent
    common_constructor :api, :data_or_id, :options, default: [{}] do
      self.options = ::EacRest::Entity.lists.option.hash_keys_validate!(options)
    end

    class << self
      def from_array_data(api, array_data, *args)
        array_data.map { |item_data| new(api, item_data, *args) }
      end
    end

    # @param entity_class [Class]
    # @param url_suffix [String]
    # @return [EacRest::Entity]
    def child_entity(entity_class, data_or_id, options = {})
      api.entity(entity_class, data_or_id, options.merge(OPTION_PARENT => self))
    end

    # @return [EacRest::Entity, nil]
    def parent_entity
      options[OPTION_PARENT]
    end

    require_sub __FILE__, include_modules: :include
  end
end
