require "rspec/request_describer/version"

module RSpec
  module RequestDescriber
    RESERVED_HEADER_NAMES = %w(
      Content-Type
      Host
    )

    SUPPORTED_METHODS = %w(
      GET
      POST
      PUT
      PATCH
      DELETE
    )

    def self.included(base)
      base.instance_eval do
        subject do
          send method, path, request_body, env
        end

        let(:request_body) do
          if headers["Content-Type"] == "application/json"
            params.to_json
          else
            params
          end
        end

        let(:headers) do
          {}
        end

        let(:params) do
          {}
        end

        let(:env) do
          headers.inject({}) do |result, (key, value)|
            key = "HTTP_" + key unless key.in?(RESERVED_HEADER_NAMES)
            key = key.gsub("-", "_").upcase
            result.merge(key => value)
          end
        end

        let(:endpoint_segments) do
          example.full_description.match(/(#{SUPPORTED_METHODS.join("|")}) ([\/a-z0-9_:]+)/).to_a
        end

        let(:method) do
          endpoint_segments[1].downcase
        end

        let(:path) do
          endpoint_segments[2].gsub(/:([^\s\/]+)/) { send($1) }
        end
      end
    end
  end
end
