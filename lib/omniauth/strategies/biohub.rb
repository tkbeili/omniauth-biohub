require 'omniauth-oauth2'
require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Biohub < OmniAuth::Strategies::OAuth2

      option :name, 'biohub'

      option :client_options, {
        :site => 'http://192.241.195.153/',
        authorize_path: "/oauth/authorize"
      }

      uid do
        raw_info["id"]
      end

      info do
        prune!({
          'email' => raw_info['email'],
          'name' => raw_info['name'],
          'first_name' => raw_info['first_name'],
          'last_name' => raw_info['last_name'],
          'gender' => raw_info['gender'],
          'birthday' => raw_info['birthday'],
          'location' => (raw_info['location'] || {})['name'],
          'zip_code' => raw_info['postal']
        })
      end

      extra do
        hash = {}
        hash['raw_info'] = raw_info unless skip_info?
        prune! hash
      end

      def raw_info
        @raw_info ||= access_token.get('/api/user').parsed || {}
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