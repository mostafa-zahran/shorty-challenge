require 'time'

module ShortyWebApp
  # ShortyStatsPresenter resposible for handling all presentation logic for
  # required stats
  class ShortyStatsPresenter
    def initialize(stats)
      @stats = stats
    end

    def perform
      {
        startDate: Time.parse(@stats[:start_date]).iso8601,
        redirectCount: @stats[:redirect_count]
      }.merge(last_seen_hash).to_json
    end

    private

    def last_seen_hash
      @stats[:redirect_count].zero? ? {} : { lastSeenDate: last_seen_value }
    end

    def last_seen_value
      Time.parse(@stats[:last_seen_date]).iso8601
    end
  end
end
