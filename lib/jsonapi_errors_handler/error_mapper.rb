module JsonapiErrorsHandler
  class ErrorMapper
    cattr_accessor :mapped_errors

    def self.map_errors!(errors_hash={})
      @@mapped_errors ||= {}
      @@mapped_errors.merge!(errors_hash)
    end

    def self.mapped_error?(error_klass)
      mapped_errors.values.include?(error_klass)
    end
  end
end

