require 'json'

module ShortyWebApp
  # Dispatcher is the class which responsible for routing and initializting
  # the data store which will be used across the app
  class Dispatcher
    def call(env)
      @req = Rack::Request.new(env)
      @shorty_controller = ShortyWebApp::ShortyController.new(data_store)
      route
    end

    private

    def data_store
      # @data_store ||= InMemoryDataStore::ShortyRepository.new
      @data_store ||= RedisDataStore::ShortyRepository.new
    end

    def respond_with(status, body)
      [status, { 'Content-Type' => 'application/json' }, Array(body)]
    end

    def stats_url?
      @req.path_info =~ %r{.+\/stats$}
    end

    def create_path?
      @req.path_info == '/shorten'
    end

    def short_code
      @req.path_info.split('/')[1]
    end

    def create_params
      JSON.parse(@req.body.read)
    end

    def route
      if @req.get?
        route_get_requests
      elsif @req.post? && create_path?
        params = create_params
        respond_with(*@shorty_controller.create(params['url'],
                                                params['shortcode']))
      else
        respond_with(HTTP_STATUS[:bad_request],
                     ErrorsPresenter.new('Bad Request').perform)
      end
    end

    def route_get_requests
      if stats_url?
        respond_with(*@shorty_controller.stats_for(short_code))
      else
        respond_with(*@shorty_controller.url_for(short_code))
      end
    end
  end
end
