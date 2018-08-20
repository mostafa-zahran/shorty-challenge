module ShortyApp
  # FindShortyUrl handle all business logic related to find shorty code url
  class FindShortyUrl < ShortyApp::Base
    def initialize(code, shorty_repo = nil)
      super(shorty_repo)
      raise ShortyApp::ShortyException::ShortCodeNotPresent if code_absent? code
      @short_code = code
    end

    def perform
      shorty = find(@short_code)
      seen!(shorty)
      { url: shorty.url }
    end

    private

    def code_absent?(code)
      code.nil? || !exists?(code)
    end
  end
end
