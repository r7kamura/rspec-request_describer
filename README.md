# RSpec::RequestDescriber

An RSpec plugin to write self-documenting request-specs.

This gem is designed for rspec-rails and rack-test.

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
RSpec.configuration.include RSpec::RequestDescriber, type: :request
```

## Usage

### subject

`RSpec::RequestDescriber` provides `subject` from its top-level description.

```ruby
# subject will be `get('/users')`.
RSpec.describe 'GET /users' do
  it { is_expected.to eq(200) }
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
    it { is_expected.to eq(200) }
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

    it 'returns users in ID order' do
      is_expected.to eq(200)

      users = JSON.parse(response.body)
      expect(users[0]['id']).to eq(1)
      expect(users[1]['id']).to eq(2)
    end
  end
end
```

### variables in URL path

You can embed variables in URL path like `/users/:id`.
In this example, the returned value of `id` method will be emobeded as its real value.

```ruby
# `subject` will be `get("/users/#{user_id}")`.
RSpec.describe 'GET /users/:user_id' do
  let(:user) do
    User.create(name: 'alice')
  end

  let(:user_id) do
    user.id
  end

  it { is_expected.to eq(200) }
end
```
