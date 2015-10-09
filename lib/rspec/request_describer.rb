require "rspec/request_describer/version"

module RSpec
  module RequestDescriber
    RESERVED_HEADER_NAMES = %w(
      Content-Type
      Host
      HTTPS
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
        subject(:send_request) do
          send _method, _path, _request_body, _env
        end

        let(:headers) do
          {}
        end

        let(:params) do
          {}
        end

        # @private
        let(:_request_body) do
          if headers.any? { |key, value| key.downcase == "content-type" && value == "application/json" }
            params.to_json
          else
            params
          end
        end

        # @private
        let(:_env) do
          headers.inject({}) do |result, (key, value)|
            key = "HTTP_" + key unless RESERVED_HEADER_NAMES.include?(key)
            key = key.gsub("-", "_").upcase
            result.merge(key => value)
          end
        end

        # @private
        let(:_endpoint_segments) do
          current_example = RSpec.respond_to?(:current_example) ? RSpec.current_example : example
          current_example.full_description.match(/(#{SUPPORTED_METHODS.join("|")}) (\S+)/).to_a
        end

        # @private
        let(:_method) do
          _endpoint_segments[1].downcase
        end

        # @private
        let(:_path) do
          _endpoint_segments[2].gsub(/:(\w+[!?=]?)/) { send($1) }
        end
      end
    end
  end
end
