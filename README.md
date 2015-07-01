# RSpec::RequestDescriber
- Simplifies your request specs with convention.
- Helps you write clean request specs by enforcing the "one HTTP request per example" rule.
- Automatically sends an HTTP request based on what you specify as a describe string following the convention.

## Setup
Add `rspec-request_describer` into your Gemfile, then run `bundle install`.

```ruby
# Gemfile
gem "rspec-request_describer"

# rspec-request_describer depends on some methods of rspec-rails (or rack-test),
# so you may need to add it unless you haven't do it yet.
gem "rspec-rails" # or "rack-test"
```

Then include `RSpec::RequestDescriber` into your `RSpec.configuration`.

```ruby
# spec/spec_helper.rb
RSpec.configuration.include RSpec::RequestDescriber
```

## Usage
RSpec::RequestDescriber provides some `subject` and `let` to your specs.

### subject
In the example below, the `subject` calls an HTTP request of GET /users,
then returns its status code.

```ruby
describe "GET /users" do
  it { should == 200 }
end
```

### headers
`headers` is provided to modify request headers.
In the below example, a token is added into Authorization request header.


```ruby
describe "GET /users" do
  context "with Authorization header" do
    before do
      headers["Authorization"] = "token 12345"
    end
    it { should == 200 }
  end
end
```

### params
You can also pass query parameter or request body by modifying `params`.
In the this example, `?sort=id` is added into URL query string.
For GET request `params` is converted into URL query string,
while it's converted into request body for the other methods
.
Note that if you specified `application/json` Content-Type request header,
`params` would be encoded into JSON format.

```ruby
describe "GET /users" do
  context "with sort parameter" do
    before do
      params["sort"] = "id"
    end

    it "returns users in ID order" do
      users = JSON.parse(response.body)
      users[0].id.should == 1
      users[1].id.should == 2
    end
  end
end
```

### variable
You can use variables in URL path like `:id`.
In this example, the returned value of `id` method is used as its real value.

```ruby
describe "GET /users/:id" do
  let(:id) do
    User.create(name: "alice").id
  end
  it { should == 200 }
end
```
