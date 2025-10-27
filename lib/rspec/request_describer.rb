# frozen_string_literal: true

require 'rspec/request_describer/version'

module RSpec
  module RequestDescriber
    class IncorrectDescribe < StandardError; end

    RESERVED_HEADER_NAMES = %w[
      content-type
      host
      https
    ].freeze

    SUPPORTED_METHODS = %w[
      DELETE
      GET
      HEAD
      PATCH
      POST
      PUT
    ].freeze

    class << self
      def included(base)
        base.instance_eval do
          subject do
            send_request
          end

          define_method(:send_request) do
            send(
              http_method,
              path,
              headers: env,
              params: request_body
            )
          end

          let(:request_body) do
            if headers.any? { |key, value| key.to_s.casecmp('content-type').zero? && value == 'application/json' }
              params.to_json
            else
              params.inject({}) do |result, (key, value)|
                result.merge(key.to_s => value)
              end
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
              key = key.to_s
              key = "HTTP_#{key}" unless RESERVED_HEADER_NAMES.include?(key.downcase)
              key = key.tr('-', '_').upcase
              result.merge(key => value)
            end
          end

          let(:endpoint_segments) do
            current_example = ::RSpec.respond_to?(:current_example) ? ::RSpec.current_example : example
            match = current_example.full_description.match(/(#{::Regexp.union(SUPPORTED_METHODS)}) (\S+)/)
            raise IncorrectDescribe, 'Please use the format "METHOD /path" for the describe' unless match

            match.to_a
          end

          # @return [String] e.g. `"get"`
          let(:http_method) do
            endpoint_segments[1].downcase
          end

          let(:path) do
            endpoint_segments[2].gsub(/:(\w+[!?=]?)/) { send(Regexp.last_match(1)) }
          end
        end
      end
    end
  end
end
