module JsonapiErrorsHandler
  class ErrorSerializer
    def initialize(error)
      @error = error
    end

    def to_h
      serializable_hash
    end

    def to_json(_payload=nil)
      to_h.to_json
    end

    private

    def serializable_hash
      {
        errors: Array.wrap(error.serializable_hash)
      }
    end

    attr_reader :error
  end
end

