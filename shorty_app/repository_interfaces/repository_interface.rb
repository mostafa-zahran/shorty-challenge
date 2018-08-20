module ShortyApp
  # RepositoryInterface is the generic module for all repository which have to
  # be implelmented by and class act as a repository
  module RepositoryInterface
    def create!(_resource)
      raise NotImplementedError
    end

    def find(_search_key)
      raise NotImplementedError
    end

    def exists?(_search_key)
      raise NotImplementedError
    end

    def save!(_resource)
      raise NotImplementedError
    end
  end
end
