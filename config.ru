require 'rubygems'
require 'bundler'
require './rack_app/shorty_web_app/shorty_web_app'
require './shorty_app/shorty_app'
require './data_stores/data_stores'

Bundler.require :default

run ShortyWebApp::Dispatcher.new
