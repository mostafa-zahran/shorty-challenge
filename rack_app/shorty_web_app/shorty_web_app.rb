require_relative './dispatcher.rb'
require_relative './controllers/shorty_controller.rb'
require_relative './presenters/shorty_stats_presenter.rb'
require_relative './presenters/errors_presenter.rb'

module ShortyWebApp
  HTTP_STATUS = {
    success: 200,
    bad_request: 400,
    not_found: 404,
    unprocessable_entity: 422,
    conflict: 409
  }.freeze
end
