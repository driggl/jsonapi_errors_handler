# JsonapiErrorsHandler

A convienient way to serialize errors in JsonAPI format (https://jsonapi.org)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi_errors_handler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonapi_errors_handler

## Usage

In your controller:

```
include JsonapiErrorsHandler
```

From this point you'll have default html errors being serialized. JsonapiErrorsHandler offers 4 predefined errors:
- JsonapiErrorsHandler::Errors::Invalid
- JsonapiErrorsHandler::Errors::Forbidden
- JsonapiErrorsHandler::Errors::NotFound
- JsonapiErrorsHandler::Errors::Unauthorized

If you rise any of errors above in any place of your application, client gets the nicely formatted error message instead of 500

### Custom errors mapping

If you want your custom errors being handled by default, just add them to th emapper

```
ErrorsMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
    'ActiveRecord::RecordInvalid' => 'JsonapiErrorsHandler::Errors::Invalid',
})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/driggl/jsonapi_errors_handler.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
