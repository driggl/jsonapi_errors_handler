# frozen_string_literal: true

require 'jsonapi_errors_handler/version'
require 'jsonapi_errors_handler/configuration'
require 'jsonapi_errors_handler/errors'
require 'jsonapi_errors_handler/error_mapper'
require 'jsonapi_errors_handler/error_serializer'

# Allows to handle ruby errors and return the serialized JSON:API output
#
module JsonapiErrorsHandler
  PREDEFINED_HASH = {
    'JsonapiErrorsHandler::Errors::Invalid' =>
      'JsonapiErrorsHandler::Errors::Invalid',
    'JsonapiErrorsHandler::Errors::Forbidden' =>
      'JsonapiErrorsHandler::Errors::Forbidden',
    'JsonapiErrorsHandler::Errors::NotFound' => '
      JsonapiErrorsHandler::Errors::NotFound',
    'JsonapiErrorsHandler::Errors::Unauthorized' =>
      'JsonapiErrorsHandler::Errors::Unauthorized'
  }.freeze

  def self.included(base)
    base.class_eval do
      ErrorMapper.map_errors!(PREDEFINED_HASH)
    end
  end

  def handle_error(error)
    log_error(error) if respond_to?(:log_error)
    # Handle every error which inherits from
    # JsonapiErrorsHandler::Errors::StandardError
    #
    if JsonapiErrorsHandler::ErrorMapper.mapped_error?(error.class.superclass.to_s)
      return render_error(error)
    end

    mapped = ErrorMapper.mapped_error(error)
    mapped ? render_error(mapped) : handle_unexpected_error(error)
  end

  def handle_unexpected_error(error)
    config = JsonapiErrorsHandler::Configuration.instance
    raise error unless config.handle_unexpected?

    notify_handle_unexpected_error(error) if respond_to?(:notify_handle_unexpected_error)

    render_error(::JsonapiErrorsHandler::Errors::StandardError.new)
  end

  def render_error(error)
    render(
      json: ::JsonapiErrorsHandler::ErrorSerializer.new(error),
      status: error.status,
      content_type: Configuration.instance.content_type
    )
  end

  def self.configure(&block)
    Configuration.instance.configure(&block)
  end
end
