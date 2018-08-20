module ShortyApp
  module ShortyException
    class UrlNotPresent < RuntimeError
    end

    class ShortCodeBadFormat < RuntimeError
    end

    class ShortCodeInUse < RuntimeError
    end

    class ShortCodeNotPresent < RuntimeError
    end
  end
end
