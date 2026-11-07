# frozen_string_literal: true

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
      def from_array_data(api, array_data, *)
        array_data.map { |item_data| new(api, item_data, *) }
      end
    end

    # @return [EacRest::Entity, nil]
    def parent_entity
      options[OPTION_PARENT]
    end

    require_sub __FILE__, include_modules: :include
  end
end
