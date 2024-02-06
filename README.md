# RSpec::RequestDescriber

[![test](https://github.com/r7kamura/rspec-request_describer/actions/workflows/test.yml/badge.svg)](https://github.com/r7kamura/rspec-request_describer/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/rspec-request_describer.svg)](https://rubygems.org/gems/rspec-request_describer)

RSpec plugin to write self-documenting request-specs.

This gem is designed for:

- [rack-test](https://github.com/rack-test/rack-test)
- [rspec-rails](https://github.com/rspec/rspec-rails)

## Setup

### Install

Add this line to your application's Gemfile:

```ruby
gem 'rspec-request_describer'
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install rspec-request_describer
```

### Include

Include `RSpec::RequestDescriber` to your example groups like this:

```ruby
require 'rspec/request_describer'

RSpec.configure do |config|
  config.include RSpec::RequestDescriber, type: :request
end
```

## Usage

Note that this is an example in a Rails app.

### subject

`RSpec::RequestDescriber` provides `subject` from its top-level description.

```ruby
# subject will be `get('/users')`.
RSpec.describe 'GET /users' do
  it 'returns 200' do
    subject
    expect(response).to have_http_status(200)
  end
end
```

### headers

If you want to modify request headers, change `headers` before calling `subject`.

```ruby
# `subject` will be `get('/users', headers: { 'Authorization' => 'token 12345' })`.
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

If you want to modify request parameters, change `params` before calling `subject`.

```ruby
# `subject` will be `get('/users', params: { 'sort' => 'id' })`.
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
In this example, the returned value of `user_id` method will be embedded as its real value.

```ruby
# `subject` will be `get("/users/#{user_id}")`.
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
