# RSpec::RequestDescriber
RSpec::RequestDescriber lets you write clean request specs by enforcing the "one HTTP request per example" rule.
HTTP requests will automatically sent before each example based on what you specify as a describe string following the convention.

## Setup

1. Add `rspec-request_describer` to your Gemfile, then run `bundle install`.
    ```ruby
    # Gemfile
    gem "rspec-request_describer"

    # rspec-request_describer depends on some methods of rspec-rails (or rack-test).
    gem "rspec-rails" # or "rack-test"
    ```


2. Include `RSpec::RequestDescriber` into your `RSpec.configuration`.
    ```ruby
    # spec/spec_helper.rb
    RSpec.configuration.include RSpec::RequestDescriber
    ```


## Basic usage
RSpec::RequestDescriber automatically generates some `subject`'s and `let`'s behind the scenes for your convenience, based on the HTTP request string that you passed in to the describe method.

```ruby
# RSpec::RequestDescriber reads the string "GET /users/:id" and
# defines the virtual subject, subject { get "/users/#{id}" }.

describe "GET /users/:id" do
  let(:id) do
    User.create(name: "alice").id
  end

  context "with invalid ID" do
    let(:id) do
      "invalid"
    end

    # Before each example, the virtual subject will be run sending the HTTP request.
    # You can write a concise example simply to test the response.
    it { should == 404 }
  end

  # You can access the response of your last HTTP request.
  context "with valid ID" do
    it "returns a user" do
      should == 200
      response.body.should include("alice")
    end
  end
end
```


## Features / Convention

###  "virtual" subject
The HTTP request string you pass in to the describe method becomes a "virtual" `subject` with an HTTP request. Before each example, one HTTP request is sent, which returns its status code and response.

```ruby
describe "GET /users" do
  it { should == 200 }
end
```

###  easy modification of request headers
The `headers` hash is provided to modify your request headers.
In this example, a token is added to Authorization request header.

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
You can also pass query parameter or request body by modifying `params` hash.
For GET requests, `params` is converted to the URL query string,
while it is included in the request body for the other HTTP methods.

In this example, `?sort=id` is added to the URL query string.
Note: If you have specified `application/json` as a Content-Type in the request header, `params` will be encoded accordingly.

```ruby
describe "GET /users" do
  context "with sort parameter" do
    before do
      params["sort"] = "id"  # `?sort=id` is added to the URL query string
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
In this example, the returned value of the `id` method is inserted into the path before sending an HTTP request.

```ruby
describe "GET /users/:id" do
  let(:id) do
    User.create(name: "alice").id
  end
  it { should == 200 }
end
```
