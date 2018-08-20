module ShortyApp
  # ShortyEntity is the business object representation for shorty object
  class ShortyEntity
    attr_reader :short_code, :url, :start_date, :last_seen_date, :redirect_count

    def initialize(short_code, url,
                   start_date = Time.now,
                   last_seen_date = nil,
                   redirect_count = 0)
      @short_code = short_code
      @url = url
      @start_date = start_date
      @last_seen_date = last_seen_date
      @redirect_count = redirect_count
    end

    def seen!
      @redirect_count += 1
      @last_seen_date = Time.now
    end
  end
end
