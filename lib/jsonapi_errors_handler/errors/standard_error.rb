# frozen_string_literal: true

require 'jsonapi_errors_handler/keys_stringifier'

module JsonapiErrorsHandler
  module Errors
    class StandardError < ::StandardError
      def initialize(title: nil, status: nil, detail: nil, message: nil, source: {})
        @title = title || 'Something went wrong'
        @detail = detail || message
        @detail ||= "We've encountered unexpected error, but our developers had been already notified about it" # rubocop:disable Metrics/LineLength
        @status = status || 500
        @source = KeysStringifier.call(source)
      end

      def serializable_hash
        {
          status: status,
          title: title,
          detail: detail,
          source: source
        }
      end

      def to_h
        serializable_hash
      end

      def to_s
        serializable_hash.to_s
      end

      attr_reader :title, :detail, :status, :source
    end
  end
end
