# frozen_string_literal: true

module EacRest
  class Entity
    module Children
      # @param entity_class [Class]
      # @param data_or_id [Hash|Object]
      # @param options [Hash]
      # @return [EacRest::Entity]
      def child_entity(entity_class, data_or_id, options = {})
        api.entity(entity_class, data_or_id, options.merge(OPTION_PARENT => self))
      end

      # @param entity_class [Class<T>]
      # @param path_suffix [String]
      # @return [Enumerable<T>]
      def child_list(entity_class, path_suffix)
        items = request(path_suffix).response.body_data
        items = yield(items) if block_given?
        items.map { |e| child_entity(entity_class, e) }
      end
    end
  end
end
