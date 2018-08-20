require 'securerandom'
module ShortyApp
  # CreateShorty handle all business logic related to create shorty code
  # including validation, auto-generation
  class CreateShorty < ShortyApp::Base
    USER_CODE_REGEX = /^[0-9a-zA-Z_]{4,}$/
    SYSTEM_CODE_REGEX = /^[0-9a-zA-Z_]{6}$/

    def initialize(url, code = nil, shorty_repo = nil)
      super(shorty_repo)
      raise ShortyApp::ShortyException::UrlNotPresent if url.nil?
      raise ShortyApp::ShortyException::ShortCodeBadFormat if bad_format?(code)
      raise ShortyApp::ShortyException::ShortCodeInUse if exists?(code)
      @url = url
      @short_code = code || generate_short_code
    end

    def perform
      create!(shorty)
      { shortcode: shorty.short_code }
    end

    private

    def shorty
      @shorty ||= ShortyApp::ShortyEntity.new(@short_code, @url)
    end

    def generate_short_code
      short_code = generate_random
      until !exists?(short_code) && short_code =~ SYSTEM_CODE_REGEX
        short_code = generate_random
      end
      short_code
    end

    def generate_random
      SecureRandom.urlsafe_base64(4).tr('-', '_')
    end

    def bad_format?(short_code)
      !short_code.nil? && short_code !~ USER_CODE_REGEX
    end
  end
end
