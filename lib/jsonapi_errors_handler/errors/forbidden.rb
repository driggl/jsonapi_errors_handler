# frozen_string_literal: true

module JsonapiErrorsHandler
  module Errors
    class Forbidden < ::JsonapiErrorsHandler::Errors::StandardError
      def initialize(message: nil)
        super(
          title: 'Forbidden request',
          status: 403,
          detail: message || 'You have no rights to access this resource',
          source: { pointer: '/request/headers/authorization' }
        )
      end
    end
  end
end
