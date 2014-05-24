require 'omniauth-oauth2'
require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class PortalClient < OmniAuth::Strategies::OAuth2
      class NoAuthorizationCodeError < StandardError; end

      option :name, 'portal_client'

      option :client_options, {
        site: "http://localhost:3000",
        authorize_path: "/oauth/authorize"
      }


      def request_phase
        super
      end
      
      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info['id'].to_s }

      info do
        {name: raw_info["name"]}
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        @raw_info ||= access_token.get('/api/user').parsed
      end

      rescue NoAuthorizationCodeError do |exception|
        if exception.response.status == 401
          session[:user_id] = nil
          session[:access_token] = nil
          redirect_to root_url, alert: "Access token expired, try signing in again."
        end
      end

      private

      def oauth_client
        @oauth_client ||= OAuth2::Client.new(ENV["OAUTH_ID"], ENV["OAUTH_SECRET"], site: "http://localhost:3000")
      end

      def access_token
        if session[:access_token]
          @access_token ||= OAuth2::AccessToken.new(oauth_client, session[:access_token])
        end
      end

    end
  end
end

OmniAuth.config.add_camelization 'github', 'PortalClient'