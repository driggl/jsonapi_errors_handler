# frozen_string_literal: true

require 'jsonapi_errors_handler/keys_stringifier'

module JsonapiErrorsHandler
  module Errors
    class StandardError < ::StandardError
      def initialize(title: nil, detail: nil, status: nil, source: {})
        @title = title || 'Something went wrong'
        @detail = detail
        @detail ||= 'We encountered unexpected error, but our developers had been already notified about it'
        @status = status || 500
        @source = KeysStringifier.call(source)
      end

      def to_h
        {
          status: status,
          title: title,
          detail: detail,
          source: source
        }
      end

      def serializable_hash
        to_h
      end

      def to_s
        to_h.to_s
      end

      attr_reader :title, :detail, :status, :source
    end
  end
end
