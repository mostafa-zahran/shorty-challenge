module ShortyWebApp
  # ShortyController is the class which should decide which use case to use
  # and which presenter to use and handle errors
  class ShortyController
    SHORT_CODE_NOT_PRESENT = "The shortcode cannot be found in \
the system".freeze
    URL_NOT_PRESNET = 'url is not present'.freeze
    SHORT_CODE_BAD_FORMAT = "The shortcode fails to meet the following \
regexp: ^[0-9a-zA-Z_]{4,}$.".freeze
    SHORT_CODE_IN_USE = 'The the desired shortcode is already in use'.freeze

    def initialize(data_store = nil)
      @data_store = data_store
    end

    def stats_for(short_code)
      stats = ShortyApp::FindShortyStats.new(short_code, @data_store).perform
      [HTTP_STATUS[:success], ShortyStatsPresenter.new(stats).perform]
    rescue ShortyApp::ShortyException::ShortCodeNotPresent
      [HTTP_STATUS[:not_found], errors(SHORT_CODE_NOT_PRESENT)]
    end

    def url_for(short_code)
      url = ShortyApp::FindShortyUrl.new(short_code, @data_store).perform
      [HTTP_STATUS[:success], url.to_json]
    rescue ShortyApp::ShortyException::ShortCodeNotPresent
      [HTTP_STATUS[:not_found], errors(SHORT_CODE_NOT_PRESENT)]
    end

    def create(url, short_code = nil)
      short_code = ShortyApp::CreateShorty.new(url, short_code, @data_store)
                                          .perform
      [HTTP_STATUS[:success], short_code.to_json]
    rescue ShortyApp::ShortyException::UrlNotPresent
      [HTTP_STATUS[:bad_request], errors(URL_NOT_PRESNET)]
    rescue ShortyApp::ShortyException::ShortCodeBadFormat
      [HTTP_STATUS[:unprocessable_entity], errors(SHORT_CODE_BAD_FORMAT)]
    rescue ShortyApp::ShortyException::ShortCodeInUse
      [HTTP_STATUS[:conflict], errors(SHORT_CODE_IN_USE)]
    end

    private

    def errors(error)
      ErrorsPresenter.new(error).perform
    end
  end
end
