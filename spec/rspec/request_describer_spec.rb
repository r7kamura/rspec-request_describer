# frozen_string_literal: true

require 'json'
require 'openssl'

RSpec.describe RSpec::RequestDescriber do
  include RSpec::RequestDescriber

  def get(*args)
    [__method__, *args]
  end

  describe 'GET /users' do
    it 'calls #get' do
      is_expected.to eq(
        [
          :get,
          '/users',
          { headers: {},
            params: {} }
        ]
      )
    end

    context 'with headers' do
      let(:headers) do
        super().merge('Authorization' => 'token 12345')
      end

      it 'calls #get with HTTP_ prefixed and upper-cased headers' do
        is_expected.to eq(
          [
            :get,
            '/users',
            { headers: { 'HTTP_AUTHORIZATION' => 'token 12345' },
              params: {} }
          ]
        )
      end
    end

    context 'with headers including reserved header name' do
      let(:headers) do
        super().merge('Https' => 'on')
      end

      it 'calls #get with headers with non HTTP_ prefixed and upper-cased headers' do
        is_expected.to eq(
          [
            :get,
            '/users',
            { headers: { 'HTTPS' => 'on' },
              params: {} }
          ]
        )
      end
    end

    context 'with symbolized keys headers' do
      let(:headers) do
        super().merge(AUTHORIZATION: 'token 12345')
      end

      it 'calls #get with HTTP_ prefixed and stringified keys headers' do
        is_expected.to eq(
          [
            :get,
            '/users',
            { headers: { 'HTTP_AUTHORIZATION' => 'token 12345' },
              params: {} }
          ]
        )
      end
    end

    context 'with headers including request body' do
      before do
        headers['X-Signature'] = "sha1=#{OpenSSL::HMAC.hexdigest('SHA1', 'secret', request_body.to_s)}"
      end

      it 'calls #get with HTTP_ prefixed and stringified keys headers' do
        is_expected.to eq(
          [
            :get,
            '/users',
            { headers: { 'HTTP_X_SIGNATURE' => 'sha1=5d61605c3feea9799210ddcb71307d4ba264225f' },
              params: {} }
          ]
        )
      end
    end

    context 'with params' do
      let(:params) do
        super().merge('sort' => 'id')
      end

      it 'calls #get with params' do
        is_expected.to eq(
          [
            :get,
            '/users',
            { headers: {},
              params: { 'sort' => 'id' } }
          ]
        )
      end
    end

    context 'with symbolized keys params' do
      let(:params) do
        super().merge(sort: 'id')
      end

      it 'calls #get with stringified keys params' do
        is_expected.to eq(
          [
            :get,
            '/users',
            { headers: {},
              params: { 'sort' => 'id' } }
          ]
        )
      end
    end

    context 'with JSON content type' do
      let(:headers) do
        super().merge('Content-Type' => 'application/json')
      end

      it 'keeps JSON content type on GET with structured params' do
        is_expected.to eq(
          [
            :get,
            '/users',
            { headers: { 'CONTENT_TYPE' => 'application/json' },
              params: {} }
          ]
        )
      end

      context 'with params' do
        let(:params) do
          super().merge(sort: 'id')
        end

        it 'keeps GET params in the query hash' do
          is_expected.to eq(
            [
              :get,
              '/users',
              { headers: { 'CONTENT_TYPE' => 'application/json' },
                params: { 'sort' => 'id' } }
            ]
          )
        end
      end
    end
  end

  describe 'GET /users/:user_id' do
    let(:user_id) do
      1
    end

    it 'calls #get with embedded variable in URL path' do
      is_expected.to eq(
        [
          :get,
          '/users/1',
          { headers: {},
            params: {} }
        ]
      )
    end
  end

  describe 'PATCH /users' do
    def patch(*args)
      [__method__, *args]
    end

    let(:headers) do
      super().merge('Content-Type' => 'application/json')
    end

    context 'with params' do
      let(:params) do
        super().merge(sort: 'id')
      end

      it 'calls #patch with a JSON body' do
        is_expected.to eq(
          [
            :patch,
            '/users',
            { headers: { 'CONTENT_TYPE' => 'application/json' },
              params: '{"sort":"id"}' }
          ]
        )
      end
    end

    context 'with custom request body' do
      let(:request_body) do
        '{ "invalid" }'
      end

      it 'passes through the raw request body' do
        is_expected.to eq(
          [
            :patch,
            '/users',
            { headers: { 'CONTENT_TYPE' => 'application/json' },
              params: '{ "invalid" }' }
          ]
        )
      end
    end

    context 'with blank params' do
      let(:params) do
        ''
      end

      it 'passes through blank string params' do
        is_expected.to eq(
          [
            :patch,
            '/users',
            { headers: { 'CONTENT_TYPE' => 'application/json' },
              params: '' }
          ]
        )
      end
    end

    context 'with nil params' do
      let(:params) do
        nil
      end

      it 'passes through nil params' do
        is_expected.to eq(
          [
            :patch,
            '/users',
            { headers: { 'CONTENT_TYPE' => 'application/json' },
              params: nil }
          ]
        )
      end
    end
  end

  context 'when the test case is under the top-level describe unexpectedly' do
    it 'handles the error' do
      expect { subject }.to raise_error(RSpec::RequestDescriber::IncorrectDescribe)
    end
  end
end
