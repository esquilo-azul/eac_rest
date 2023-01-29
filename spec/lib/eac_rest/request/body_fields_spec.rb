# frozen_string_literal: true

require 'eac_rest/request/body_fields'

::RSpec.describe ::EacRest::Request::BodyFields do
  describe '#to_h' do
    [
      [
        { field1: 'value1', field2: %w[value2 value3] },
        { 'field1' => ['value1'], 'field2' => %w[value2 value3] }
      ], [
        'field1=value1&field2=value2',
        nil
      ], [
        [%w[field1 value1], %w[field2 value2], %w[field2 value3]],
        { 'field1' => ['value1'], 'field2' => %w[value2 value3] }
      ]
    ].each do |d|
      source_body = d[0]
      expected_result = d[1]
      context "when source_body is #{source_body}" do
        let(:instance) { described_class.new(source_body) }

        it do
          expect(instance.to_h).to eq(expected_result)
        end
      end
    end
  end
end
