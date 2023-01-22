# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/fs/temp'
require 'eac_ruby_utils/yaml'

class RequestBuilder
  class << self
    def from_file(api, path)
      new(api, ::EacRubyUtils::Yaml.load_file(path))
    end
  end

  FILE_FIELD_PARSER = /\A@(.+)\z/.to_parser { |m| m[1] }

  common_constructor :api, :data do
    self.data = data.with_indifferent_access
  end

  def result
    r = %i[verb headers].inject(selected_api.request(data.fetch(:url_suffix))) do |a, e|
      data[e].if_present(a) { |v| a.send(e, v) }
    end
    data[:body_data].if_present(r) { |v| r.body_data(build_body_data(v)) }
  end

  def build_body_data(source)
    return source unless source.is_a?(::Hash)

    source.map { |k, v| build_body_field(k, v) }
  end

  def build_body_field(name, value)
    FILE_FIELD_PARSER.parse(name).if_present([name, value]) do |v|
      [v, file_with_value(value)]
    end
  end

  def file_with_value(value)
    r = ::EacRubyUtils::Fs::Temp.directory.join('basename')
    r.write(value)
    ::File.new(r.to_path)
  end

  def selected_api
    data[:auth].if_present(api) do |v|
      api.class.new(api.root_url, v.fetch(:username), v.fetch(:password))
    end
  end
end
