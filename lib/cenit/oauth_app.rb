require "cenit/oauth_app/version"

module Cenit
  module OauthApp
    include BuildInApps

    def self.included(m)
      m.extend(Endpoints)
      m.include(Helpers)
      super
    end
  end
end

require 'cenit/oauth_app/code'
require 'cenit/oauth_app/endpoints'
require 'cenit/oauth_app/helpers'
