# frozen_string_literal: true

module JsonapiErrorsHandler
  class ErrorMapper
    @mapped_errors = {}

    class << self
      attr_reader :mapped_errors
    end

    def self.map_errors!(errors_hash = {})
      @mapped_errors.merge!(errors_hash)
    end

    def self.mapped_error?(error_klass)
      mapped_errors.key?(error_klass)
    end

    def self.mapped_error(error)
      return error if descendant_of_predefined?(error)

      error_class = error.is_a?(Class) ? error.to_s : error.class.name
      root_class = error_class.split('::').first
      mapped = mapped_errors[error_class] || mapped_errors[root_class]
      return unless mapped

      Object.const_get(mapped).new
    end

    def self.descendant_of_predefined?(error)
      return false if error.is_a?(Class)

      error.class < JsonapiErrorsHandler::Errors::StandardError
    end
  end
end
