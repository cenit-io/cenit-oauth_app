module Cenit
  module OauthApp
    module Endpoints
      module_function

      def oauth_authorization_for(scopes)

        controller do

          get '/authorization/:id' do

            error = status = nil
            if (auth = Setup::Authorization.where(id: params[:id]).first)
              token = auth.metadata['redirect_token']
              if token == params[:redirect_token]
                if (redirect_uri = auth.metadata['redirect_uri'])
                  if auth.authorized?
                    code = Code.create_from_json(metadata: { auth_id: auth.id.to_s })
                    redirect_uri = "#{redirect_uri}?code=#{URI.encode(code.value)}"
                    if (state = auth.metadata['state'])
                      redirect_uri = "#{redirect_uri}&state=#{URI.encode(state)}"
                    end
                    redirect_to redirect_uri
                  else
                    redirect_to redirect_uri + '?error=' + URI.encode('Not authorized')
                  end
                else
                  error = 'Invalid authorization state'
                  status = :not_acceptable
                end
              else
                error = 'Invalid access'
                status = :not_acceptable
              end
            else
              error = 'Authorization not found'
              status = :not_found
            end
            if error
              render json: { error: error }, status: status
            end
          end

          get '/authorize' do
            if (redirect_uri = params[:redirect_uri]) && redirect_uris.include?(redirect_uri)
              auth = app.create_authorization!(
                namespace: app.namespace,
                scopes: scopes,
                metadata: { redirect_uri: redirect_uri, state: params[:state] }
              )
              authorize(auth)
            else
              render json: { error: "Invalid redirect_uri param: #{redirect_uri}" }, status: :bad_request
            end
          end

          post '/token' do
            auth = nil
            value = request.body.read
            if (code = Code.where(value: value).first) && code.active?
              auth = Setup::Authorization.where(id: code.metadata['auth_id']).first
              code.destroy
            end
            if auth
              render json: {
                access_token: auth.access_token,
                expiration_date: (auth.authorized_at || Time.now) + (auth.token_span || 0),
                id_token: auth.id_token,
                host: Cenit.homepage
              }
              auth.destroy
            else
              render json: { error: 'Invalid code' }, status: :unauthorized
            end
          end
        end
      end

      def default_url(default_url)
        default_redirect_uris << -> { ENV["#{self}:default_uri"].presence || default_url }
      end
    end
  end
end