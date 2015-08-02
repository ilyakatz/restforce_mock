[![Build Status](https://travis-ci.org/ilyakatz/restforce_mock.svg?branch=master)](https://travis-ci.org/ilyakatz/restforce_mock)

# RestforceMock

Mock out [Restforce](https://github.com/ejholmes/restforce) in tests

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do

  gem 'restforce_mock'

end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restforce_mock

## Usage

To mock out Restforce global in your test environment

```ruby
Restforce::Client = RestforceMoc::Client
```

This will direct all calls to `Restforce to RestforceMock`. Test as usual.

### Mimicking Salesforce data

To mimic Salesforce database, add some data to the RestfoceMock sandbox

```ruby
  RestforceMock::Sandbox.add_object("Contact", "HGUKK674J79HjsH", { Name__c: "John" })
```

RestforceMock sandbox is *shared across all your tests* (same way as real Salesforce instace would be), hence,
after completion of tests make sure to clean up if necessary

```ruby
  RestforceMock::Sandbox.reset!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/restforce_mock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## Dedication

This gem is dedicated to memory of Adrian P.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

