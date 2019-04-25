# frozen_string_literal: true

module JsonapiErrorsHandler
  module Errors
    class NotFound < ::JsonapiErrorsHandler::Errors::StandardError
      def initialize(message: nil)
        super(
          title: 'Record not Found',
          status: 404,
          detail: message || 'We could not find the object you were looking for.',
          source: { pointer: '/request/url/:id' }
        )
      end
    end
  end
end
