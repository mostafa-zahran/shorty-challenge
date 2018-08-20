require "rubygems"
require "bundler"

Bundler.require :default

require './rack_app/shorty_web_app/shorty_web_app'
require './shorty_app/shorty_app'
require './data_stores/data_stores'
require 'simplecov'

SimpleCov.start
RSpec.configure do |config|
end
