module ShortyApp
  # FindShortyStats handle all business logic related to find shorty code
  # stats
  class FindShortyStats < ShortyApp::Base
    def initialize(code, shorty_repo = nil)
      super(shorty_repo)
      raise ShortyApp::ShortyException::ShortCodeNotPresent if code_absent? code
      @short_code = code
    end

    def perform
      shorty = find(@short_code)
      {
        start_date: shorty.start_date,
        last_seen_date: shorty.last_seen_date,
        redirect_count: shorty.redirect_count
      }
    end

    private

    def code_absent?(code)
      code.nil? || !exists?(code)
    end
  end
end
