# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRest
  class Entity
    module Data
      common_concern

      # @return [Hash]
      def data
        if internal_data.blank?
          self.internal_data = data_or_id_data? ? data_or_id : data_from_id
        end

        internal_data
      end

      # @return [Boolean]
      def data_or_id_data?
        data_or_id.is_a?(::Hash)
      end

      # @return [Hash]
      def data_from_id
        raise_abstract_method __method__
      end

      # @return [Object]
      def id
        data_or_id_data? ? id_from_data : data_or_id
      end

      # @return [Object]
      def id_from_data
        raise_abstract_method __method__
      end

      private

      attr_accessor :internal_data
    end
  end
end
