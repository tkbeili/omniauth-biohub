require 'omniauth-oauth2'
require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Biohub < OmniAuth::Strategies::OAuth2
      class NoAuthorizationCodeError < StandardError; end

      option :name, 'biohub'

      option :client_options, {
        authorize_path: "/oauth/authorize"
      }


      uid do
        raw_info[0]["id"]
      end

      # info do
      #   {name: raw_info[0]["email"]}
      # end

      info do
        prune!({
          'email' => raw_info[0]['email'],
          'name' => raw_info[0]['name'],
          'first_name' => raw_info[0]['first_name'],
          'last_name' => raw_info[0]['last_name'],
          'location' => (raw_info[0]['location'] || {})['name']
        })
      end

      extra do
        hash = {}
        hash['raw_info'] = raw_info unless skip_info?
        prune! hash
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/users').parsed || {}
      end


      def callback_phase
        with_authorization_code! do
          super
        end
      rescue NoAuthorizationCodeError => e
        fail!(:no_authorization_code, e)
      rescue UnknownSignatureAlgorithmError => e
        fail!(:unknown_signature_algoruthm, e)
      end

      private 
      
      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

    end
  end
end

# OmniAuth.config.add_camelization 'github', 'PortalClient'