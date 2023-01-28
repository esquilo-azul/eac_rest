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

    context 'when source_body has a file' do
      let(:file) do
        temp = ::EacRubyUtils::Fs::Temp.file
        temp.write('TEMPORARY')
        ::File.new(temp.to_path)
      end
      let(:source_body) { { file1: file } }
      let(:instance) { described_class.new(source_body) }
      let(:expected_file) { ::Faraday::Multipart::FilePart.new(file.path, 'text/plain') }

      %w[class original_filename local_path content_type].each do |attr|
        it do
          expect(instance.to_h.fetch('file1').first.send(attr)).to eq(expected_file.send(attr))
        end
      end
    end
  end
end
