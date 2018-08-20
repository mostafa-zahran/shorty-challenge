module RedisDataStore
  # ShortyRepository it is a repository which impelments required methods to use
  # redis data store
  class ShortyRepository
    include ShortyApp::ShortRepositoryInterface

    def create!(resource)
      $redis.set(key(resource), value(resource))
    end

    def find(search_key)
      raise KeyError unless exists?(search_key)
      params = JSON.parse($redis.get(search_key))
      ShortyApp::ShortyEntity.new(search_key,
                                  params['url'],
                                  params['start_date'],
                                  params['last_seen_date'],
                                  params['redirect_count'])
    end

    def exists?(search_key)
      $redis.exists(search_key)
    end

    def save!(resource)
      $redis.set(key(resource), value(resource))
    end

    private

    def value(resource)
      {
        url: resource.url,
        start_date: resource.start_date,
        last_seen_date: resource.last_seen_date,
        redirect_count: resource.redirect_count
      }.to_json
    end

    def key(resource)
      resource.short_code
    end
  end
end
