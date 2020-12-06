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
    mapped = ErrorMapper.mapped_error(error)
    mapped ? render_error(mapped) : handle_unexpected_error(error)
  end

  def handle_unexpected_error(error)
    return raise error unless configuration.handle_unexpected?

    log_error(error) if respond_to?(:log_error)
    render_error(::JsonapiErrorsHandler::Errors::StandardError.new)
  end

  def render_error(error)
    render json: ::JsonapiErrorsHandler::ErrorSerializer.new(error), status: error.status.to_i
  end

  def self.configure(&block)
    Configuration.instance.configure(&block)
  end

  def configuration
    Configuration.instance
  end
end
