# frozen_string_literal: true

require 'singleton'

module JsonapiErrorsHandler
  # Configuration class allowing to set up the initial behavior for the gem
  #
  class Configuration
    include Singleton

    attr_writer :handle_unexpected
    attr_accessor :content_type
    # Allows to override the configuration options
    # @param [Block] - list of options to be overwritten
    #
    def configure
      yield(self) if block_given?
    end

    # Checks if unexpected errors should be handled by the gem
    # @return [Boolean]
    #
    def handle_unexpected?
      @handle_unexpected
    end

    private

    def initialize
      @handle_unexpected = false
      @content_type = 'application/vnd.api+json'
    end
  end
end
