#-*- coding: utf-8 -*-#
require Rails.root.join("config/environments/production")

Bademporium::Application.configure do
  config.action_mailer.default_url_options = { :host => 'bademporium-staging.heroku.com'}
end