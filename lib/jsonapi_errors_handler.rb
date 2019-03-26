require "jsonapi_errors_handler/version"
require "jsonapi_errors_handler/error_mapper"
require "jsonapi_errors_handler/error_serializer"

module JsonapiErrorsHandler
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      ErrorsMapper.map_errors!({
        'JsonapiErrorsHandler::Errors::Invalid' => 'JsonapiErrorsHandler::Errors::Invalid',
        'JsonapiErrorsHandler::Errors::Forbidden' => 'JsonapiErrorsHandler::Errors::Forbidden',
        'JsonapiErrorsHandler::Errors::NotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
        'JsonapiErrorsHandler::Errors::Unauthorized' => 'JsonapiErrorsHandler::Errors::Unauthorized'
      })

      rescue_from(::StandardError, with: lambda { |e| handle_error(e) })
    end
  end

  module ClassMethods
    def handle_error(e)
      mapped = map_error(e)
      unless Rails.env.development?
        # notify about unexpected_error unless mapped
        mapped ||= ::JsonapiErrorsHandler::Errors::StandardError.new
      end
      if mapped
        render_error(mapped)
      else
        raise e
      end
    end

    def map_error(e)
      error_klass = e.class.name
      return e if ErrorsMapper.mapped_error?(error_klass)
      ErrorsMapper.mapped_errors[error_klass]&.constantize&.new
    end

    def render_error(error)
      render json: ::JsonapiErrorHandler::ErrorSerializer.new(error), status: error.status
    end
  end
end
