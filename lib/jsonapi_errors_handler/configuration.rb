# frozen_string_literal: true

require 'singleton'

module JsonapiErrorsHandler
  class Configuration
    include Singleton

    attr_writer :handle_unexpected

    def configure
      yield(self) if block_given?
    end

    def handle_unexpected?
      @handle_unexpected
    end

    private

    def initialize
      @handle_unexpected = false
    end
  end
end
