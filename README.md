# RSpec::RequestDescriber

[![test](https://github.com/r7kamura/rspec-request_describer/actions/workflows/test.yml/badge.svg)](https://github.com/r7kamura/rspec-request_describer/actions/workflows/test.yml)

RSpec plugin to write self-documenting request-specs.

This gem is designed for:

- [rack-test](https://github.com/rack-test/rack-test)
- [rspec-rails](https://github.com/rspec/rspec-rails)

## Setup

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'rspec-request_describer'
end
```

And then include `RSpec::RequestDescriber`:

```ruby
# spec/rails_helper.rb
RSpec.configure do |config|
  config.include RSpec::RequestDescriber, type: :request
end
```

## Usage

Write HTTP method and URL path in the top-level description of your request-specs.

```ruby
# spec/requests/users/index_spec.rb
RSpec.describe 'GET /users' do
  it 'returns 200' do
    subject
    expect(response).to have_http_status(200)
  end
end
```

Internally, `RSpec::RequestDescriber` defines `subject` and some `let` from its top-level description like this:

```ruby
RSpec.describe 'GET /users' do
  subject do
    send_request
  end

  def send_request
    send(http_method, path, headers:, params:)
  end

  let(:http_method) do
    'get'
  end

  let(:path) do
    '/users'
  end

  let(:headers) do
    {}
  end

  let(:params) do
    {}
  end
  
  let(:query) do
    {}
  end

  it 'returns 200' do
    subject
    expect(response).to have_http_status(200)
  end
end
```

### headers

If you want to modify request headers, change `headers`:

```ruby
RSpec.describe 'GET /users' do
  context 'with Authorization header' do
    before do
      headers['Authorization'] = 'token 12345'
    end

    it 'returns 200' do
      subject
      expect(response).to have_http_status(200)
    end
  end
end
```

### params

If you want to modify request parameters, change `params`:

```ruby
RSpec.describe 'GET /users' do
  context 'with sort parameter' do
    before do
      params['sort'] = 'id'
    end

    it 'returns 200 with expected JSON body' do
      subject
      expect(response).to have_http_status(200)
      expect(response.parsed_body).to match(
        [
          hash_including('id' => 1),
          hash_including('id' => 2),
        ]
      )
    end
  end
end
```

### path parameters

You can embed variables in URL path like `/users/:user_id`.
In this example, the returned value from `#user_id` method will be embedded as its real value.

```ruby
RSpec.describe 'GET /users/:user_id' do
  let(:user) do
    User.create(name: 'alice')
  end

  let(:user_id) do
    user.id
  end

  it 'returns 200' do
    subject
    expect(response).to have_http_status(200)
  end
end
```

### query parameters

If you want to modify query parameters, change `query`:

```ruby
RSpec.describe 'GET /users' do
  context 'with query parameter' do
    let(:query)
      { status: 'active', sort: 'id' }
    end

    it 'returns 200' do
      subject
      expect(path).to eq 'users?status=active&sort=id'
    end
  end
end
```
