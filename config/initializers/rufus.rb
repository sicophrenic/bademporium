#-*- coding: utf-8 -*-#
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new

# Prevent Heroku from spinning down Syncmark
# Heroku idles dynos that have not been active for 1hr, so to keep the dyno from being shut down
if Rails.env.production?
  scheduler.every '1m' do
    require 'net/http'
    require 'uri'
    Net::HTTP.get_response(URI.parse(ENV['HEROKU_URL']))
  end
end