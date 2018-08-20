require_relative './repository_interface.rb'

module ShortyApp
  # ShortRepositoryInterface is an interface for shorty repository, it have to
  # be implemented to any shorty repository for all data stores implementations
  module ShortRepositoryInterface
    extend ShortyApp::RepositoryInterface
    include ShortyApp::RepositoryInterface
  end
end
