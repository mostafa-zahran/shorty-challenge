module InMemoryDataStore
  # ShortyRepository it is a repository which impelments required methods to use
  # in memory data store
  class ShortyRepository
    include ShortyApp::ShortRepositoryInterface

    def create!(resource)
      $storage[key(resource)] = value(resource)
    end

    def find(search_key)
      raise KeyError unless exists?(search_key)
      params = $storage[search_key]
      ShortyApp::ShortyEntity.new(search_key,
                                  params[:url],
                                  params[:start_date],
                                  params[:last_seen_date],
                                  params[:redirect_count])
    end

    def exists?(search_key)
      !$storage[search_key].nil?
    end

    def save!(resource)
      $storage[key(resource)] = value(resource)
    end

    private

    def value(resource)
      {
        url: resource.url,
        start_date: resource.start_date.to_s,
        last_seen_date: resource.last_seen_date.to_s,
        redirect_count: resource.redirect_count
      }
    end

    def key(resource)
      resource.short_code
    end
  end
end
