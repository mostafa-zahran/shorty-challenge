module ShortyWebApp
  # ErrorsPresenter is responsible for presenting errosr messages
  class ErrorsPresenter
    def initialize(desc)
      @desc = desc
    end

    def perform
      { errors: @desc }.to_json
    end
  end
end
