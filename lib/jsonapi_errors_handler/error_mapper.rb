# frozen_string_literal: true

module JsonapiErrorsHandler
  class ErrorMapper
    @@mapped_errors = {}
    def self.mapped_errors
      @@mapped_errors
    end

    def self.map_errors!(errors_hash = {})
      @@mapped_errors.merge!(errors_hash)
    end

    def self.mapped_error?(error_klass)
      mapped_errors.value?(error_klass)
    end
  end
end
