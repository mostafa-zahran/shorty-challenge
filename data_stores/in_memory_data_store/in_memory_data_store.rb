require_relative './shorty_repository.rb'

# InMemoryDataStore initialization for all Repositories that will depend on
# in memory data store
module InMemoryDataStore
  $storage ||= {}
end
