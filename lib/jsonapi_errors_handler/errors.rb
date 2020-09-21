# frozen_string_literal: true

module JsonapiErrorsHandler
  # A set of predefined, serializable HTTP error objects
  #
  module Errors
  end
end

require 'jsonapi_errors_handler/errors/standard_error'
require 'jsonapi_errors_handler/errors/forbidden'
require 'jsonapi_errors_handler/errors/invalid'
require 'jsonapi_errors_handler/errors/not_found'
require 'jsonapi_errors_handler/errors/unauthorized'
