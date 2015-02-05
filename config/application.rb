require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ballot
  class Application < Rails::Application
  
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { api_token: 'df7d7137-7e9a-4e52-8012-8089f58caafe' }

  end
end
