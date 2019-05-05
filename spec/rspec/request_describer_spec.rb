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
          headers: {},
          params: {}
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
            headers: { 'HTTP_AUTHORIZATION' => 'token 12345' },
            params: {}
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
            headers: { 'HTTPS' => 'on' },
            params: {}
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
            headers: { 'HTTP_AUTHORIZATION' => 'token 12345' },
            params: {}
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
            headers: {},
            params: { 'sort' => 'id' }
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
            headers: {},
            params: { 'sort' => 'id' }
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
          headers: {},
          params: {}
        ]
      )
    end
  end
end
