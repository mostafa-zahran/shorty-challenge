module ShortyApp
  # Base is the parent for all shorty usecases and contains all common logic
  # which used in shorty_repo data store to isolation
  class Base
    def initialize(shorty_repo)
      @shorty_repo = shorty_repo || ShortyApp::ShortRepositoryInterface
    end

    private

    def create!(shorty)
      @shorty_repo.create!(shorty)
    end

    def find(short_code)
      @shorty_repo.find(short_code)
    end

    def exists?(short_code)
      @shorty_repo.exists?(short_code)
    end

    def seen!(shorty)
      shorty.seen!
      @shorty_repo.save!(shorty)
    end
  end
end
