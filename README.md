[![Gem Version](https://badge.fury.io/rb/jsonapi_errors_handler.svg)](https://badge.fury.io/rb/jsonapi_errors_handler)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/6dba6e4556354789809185e0decde4f8)](https://www.codacy.com/gh/driggl/jsonapi_errors_handler?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=driggl/jsonapi_errors_handler&amp;utm_campaign=Badge_Grade)
[![Codacy Badge](https://app.codacy.com/project/badge/Coverage/6dba6e4556354789809185e0decde4f8)](https://www.codacy.com/gh/driggl/jsonapi_errors_handler?utm_source=github.com&utm_medium=referral&utm_content=driggl/jsonapi_errors_handler&utm_campaign=Badge_Coverage)
![Run tests](https://github.com/driggl/jsonapi_errors_handler/workflows/Run%20tests/badge.svg?branch=master)

# JsonapiErrorsHandler

A convienient way to serialize errors in [Jsonapi standard](https://jsonapi.org)

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'jsonapi_errors_handler'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install jsonapi_errors_handler
```

## Usage

In your controller:

```ruby
  include JsonapiErrorsHandler
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
```

From this point you'll have default html errors being serialized. JsonapiErrorsHandler offers 4 predefined errors:

*   [JsonapiErrorsHandler::Errors::Invalid](https://github.com/driggl/jsonapi_errors_handler/blob/master/lib/jsonapi_errors_handler/errors/invalid.rb)
*   [JsonapiErrorsHandler::Errors::Forbidden](https://github.com/driggl/jsonapi_errors_handler/blob/master/lib/jsonapi_errors_handler/errors/forbidden.rb)
*   [JsonapiErrorsHandler::Errors::NotFound](https://github.com/driggl/jsonapi_errors_handler/blob/master/lib/jsonapi_errors_handler/errors/not_found.rb)
*   [JsonapiErrorsHandler::Errors::Unauthorized](https://github.com/driggl/jsonapi_errors_handler/blob/master/lib/jsonapi_errors_handler/errors/unauthorized.rb)

If you rise any of errors above in any place of your application, client gets the nicely formatted error message instead of 500

### Handling unexpected errors

If you want to handle all the errors in your API application to deliver nicely formatted JSON response about 500 instead crashing the server, add this when your application loads:

```ruby
require 'jsonapi_errors_handler'

JsonapiErrorsHandler.configure do |config|
  config.handle_unexpected = true
end
```

### Custom errors mapping

If you want your custom errors being handled by default, just add them to the mapper

```ruby
  include JsonapiErrorsHandler
  ErrorMapper.map_errors!({
      'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
  })
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
```

### Handling rails-specific validation errors

To handle validation errors from ActiveRecord or ActiveModel, you need to write custom
error handler:

```ruby
rescue_from ActiveRecord::RecordInvalid, with: lambda { |e| handle_validation_error(e) }
rescue_from ActiveModel::ValidationError, with: lambda { |e| handle_validation_error(e) }

def handle_validation_error(error)
  error_model = error.try(:model) || error.try(:record)
  mapped = JsonapiErrorsHandler::Errors::Invalid.new(errors: error_model.errors)
  render_error(mapped)
end
```

### Custom error logging

When you'll include the `jsonapi_errors_handler` to your controller, all errors will be handled and delivered to the client in the nice, formatted
way.

However, you'd probably like to have a way to log the risen error on your own to send notifications to developers that
something unexpected happened.

To do so, just implement the `log_error` method in your controller, that accepts the risen error as an argument.

```
  def log_error(error)
    #do the fancy logging here
  end
```

### Custom error responses

By default, we deliver hardcoded responses. You can check out the defined error classes for details

*   [JsonapiErrorsHandler::Errors::Invalid](https://github.com/driggl/jsonapi_errors_handler/blob/master/lib/jsonapi_errors_handler/errors/invalid.rb)
*   [JsonapiErrorsHandler::Errors::Forbidden](https://github.com/driggl/jsonapi_errors_handler/blob/master/lib/jsonapi_errors_handler/errors/forbidden.rb)
*   [JsonapiErrorsHandler::Errors::NotFound](https://github.com/driggl/jsonapi_errors_handler/blob/master/lib/jsonapi_errors_handler/errors/not_found.rb)
*   [JsonapiErrorsHandler::Errors::Unauthorized](https://github.com/driggl/jsonapi_errors_handler/blob/master/lib/jsonapi_errors_handler/errors/unauthorized.rb)

If you want to have custom error responses being delivered, just create your own `Api::Errors` that inherits from `JsonapiErrorsHandler::StandardError`

### Localization example

If you want to localize your responses, just create a class:

```
  module Api::Errors
    class Forbidden < ::JsonapiErrorsHandler::Errors::StandardError
      def initialize(*)
        super(
          title: I18n.t('api.errors.forbidden.title'),
          status: 403,
          detail: I18n.t('api.errors.forbidden.detail'),
          source: { pointer: '/request/headers/authorization' }
        )
      end
    end
  end
```

## Guides & tutorials

*   [Handling Exceptions in Rails Applications](https://driggl.com/blog/a/handling-exceptions-in-rails-applications) - Gem's concept explained in details
*   [JsonApi Errors Handler Guide](https://driggl.com/blog/a/json-api-errors-handler)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/driggl/jsonapi_errors_handler>.

**How to contribute:**

1.  Fork repository
2.  Install [Rubocop](https://github.com/rubocop-hq/rubocop) - make sure you run it before commiting changes
3.  Commit changes
    *   Keep commits small and atomic
    *   Start commit message from keywords (Add/Remove/Change/Refactor/Move/Rename/Upgrade/Downgrade)
    *   Keep commits imperative style

4.  Create Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
