# frozen_string_literal: true

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

    context 'with query' do
      let(:query) do
        super().merge(status: 'active', sort: 'id')
      end

      it 'calls #get with query string' do
        is_expected.to eq(
          [
            :get,
            '/users?status=active&sort=id',
            { headers: {},
              params: {} }
          ]
        )
      end
    end
  end

  describe 'GET /users/:user_id' do
    let(:user_id) do
      1
    end

    it 'calles #get with embeded variable in URL path' do
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

  context 'when the test case is under the top-level describe unexpectedly' do
    it 'handles the error' do
      expect { subject }.to raise_error(RSpec::RequestDescriber::IncorrectDescribe)
    end
  end
end
