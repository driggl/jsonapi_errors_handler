module JsonapiErrorsHandler
  module Errors

  end
end

require_dependency 'jsonapi_errors_handler/errors/standard_error'
require_dependency 'jsonapi_errors_handler/errors/forbidden'
require_dependency 'jsonapi_errors_handler/errors/invalid'
require_dependency 'jsonapi_errors_handler/errors/not_found'
require_dependency 'jsonapi_errors_handler/errors/unauthorized'
