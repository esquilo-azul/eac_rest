# frozen_string_literal: true

require 'addressable'
require 'eac_docker/images/named'
require 'eac_docker/rspec/stub_image'
require 'eac_ruby_utils/core_ext'

class HttpEchoServer < ::EacDocker::Rspec::StubImage
  # https://hub.docker.com/r/mendhak/http-https-echo
  SOURCE_TAG = 'mendhak/http-https-echo:26'
  SCHEMES = { http: 8080, https: 8443 }.freeze
  SERVER_READY_MESSAGE_PATTERN = /Listening on ports/.freeze

  set_callback :on_container, :before, :wait_for_server

  def initialize
    super(::EacDocker::Images::Named.new(SOURCE_TAG))
  end

  # @return [Addressable::URI]
  SCHEMES.each do |scheme, port|
    define_method "#{scheme}_root_url" do
      ::Addressable::URI.new(scheme: scheme.to_s, host: container.hostname, port: port)
    end
  end

  def wait_for_server
    r = nil
    loop do
      r = container.logs
      break if r.present? && SERVER_READY_MESSAGE_PATTERN =~ r

      sleep 0.1.seconds
    end
  end
end
