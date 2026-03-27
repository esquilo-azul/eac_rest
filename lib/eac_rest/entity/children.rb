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
    end
  end
end
