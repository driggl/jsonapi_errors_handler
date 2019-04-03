# frozen_string_literal: true

module JsonapiErrorsHandler
  module Errors
    class StandardError < ::StandardError
      def initialize(title: nil, detail: nil, status: nil, source: {})
        @title = title || "Something went wrong"
        @detail = detail || "We encountered unexpected error, but our developers had been already notified about it"
        @status = status || 500
        @source = KeysStringifier.(source)
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

class KeysStringifier
  def self.call(hash)
    hash.reduce({}) do |h, (k,v)|
      new_val = v.is_a?(Hash) ? self.call(v) : v
      h.merge({k.to_s => new_val})
    end
  end
end
