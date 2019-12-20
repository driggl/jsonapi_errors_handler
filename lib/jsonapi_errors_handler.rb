# frozen_string_literal: true

require 'irb'
require 'jsonapi_errors_handler/version'
require 'jsonapi_errors_handler/errors'
require 'jsonapi_errors_handler/error_mapper'
require 'jsonapi_errors_handler/error_serializer'

module JsonapiErrorsHandler
  def self.included(base)
    base.class_eval do
      ErrorMapper.map_errors!(
        'JsonapiErrorsHandler::Errors::Invalid' => 'JsonapiErrorsHandler::Errors::Invalid',
        'JsonapiErrorsHandler::Errors::Forbidden' => 'JsonapiErrorsHandler::Errors::Forbidden',
        'JsonapiErrorsHandler::Errors::NotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
        'JsonapiErrorsHandler::Errors::Unauthorized' => 'JsonapiErrorsHandler::Errors::Unauthorized'
      )
    end
  end

  def handle_error(error)
    mapped = map_error(error)
    log_error(error) if respond_to?(:log_error) && !mapped
    mapped ||= ::JsonapiErrorsHandler::Errors::StandardError.new
    render_error(mapped)
  end

  def map_error(error)
    error_klass = error.is_a?(Class) ? error : error.class

    return nil unless ErrorMapper.mapped_error?(error_klass.to_s)
    return error if error.instance_of?(error_klass)

    Object.const_get(ErrorMapper.mapped_errors[error_klass.to_s]).new
  end

  def render_error(error)
    render json: ::JsonapiErrorsHandler::ErrorSerializer.new(error), status: error.status
  end
end
