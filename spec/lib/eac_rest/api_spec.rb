# frozen_string_literal: true

require 'eac_rest/api'

::RSpec.describe ::EacRest::Api do
  let(:instance) { described_class.new(http_server.http_root_url) }
  let(:http_server) { ::HttpEchoServer.new }

  around do |example|
    http_server.on_container(&example)
  end

  include_examples 'source_target_fixtures', __FILE__

  def source_data(source_file)
    remove_variable_values(
      ::JSON.parse(
        ::RequestBuilder.from_file(instance, source_file).result.response.body_str
      )
    )
  end

  def remove_variable_values(obj)
    if obj.is_a?(::Hash)
      remove_variable_values_from_hash(obj)
    elsif obj.is_a?(::Enumerable)
      remove_variable_values_from_enumerable(obj)
    end
    obj
  end

  def remove_variable_values_from_hash(hash)
    %w[host hostname ip].each { |key| hash.delete(key) }
    hash.each_value { |value| remove_variable_values(value) }
  end

  def remove_variable_values_from_enumerable(enumerable)
    enumerable.each { |value| remove_variable_values(value) }
  end

  context 'with self signed https server' do
    let(:instance) { described_class.new(http_server.https_root_url) }
    let(:request_base) { instance.request('/any/path') }
    let(:response_body) { request.response.body_str }

    context 'when no additional flag' do
      let(:request) { request_base }

      it do
        expect { response_body }.to(raise_error(::EacRest::Error))
      end
    end

    context 'when ssl_verify disabled' do
      let(:request) { request_base.ssl_verify(false) }

      it do
        expect { response_body }.not_to raise_error
      end
    end
  end
end
