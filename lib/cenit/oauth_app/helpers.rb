module Cenit
  module OauthApp
    module Helpers

      def self.included(m)
        m.controller do

          def oauth_user
            access_token = request.headers['Authorization'].to_s.split(' ')[1].to_s
            User.where(id: app.user_id_for(access_token)).first
          end
        end
      end
    end
  end
end