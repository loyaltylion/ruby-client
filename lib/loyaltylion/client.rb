require 'httparty'

module LoyaltyLion
  class Client
    include HTTParty
    base_uri 'http://api.loyaltylion.com/v1'

    attr_reader :token, :secret

    def initialize(token, secret, options = {})
      @token = token
      @secret = secret
      @auth = { :token => token, :secret => secret }
      if options[:base_uri]
        Client.base_uri options[:base_uri]
      end
    end

    def post(path, params)
      self.class.post(path, :query => @auth.merge(params))
    end

    def track(name, customer_id, customer_email, properties = {})
      params = {
        :name => name,
        :date => DateTime.now.iso8601,
        :customer_id => customer_id,
        :customer_email => customer_email,
        :properties => properties
      }
      response = post('/events', params)
      return {
        :success => response.code == 201
      }
    end

    def get_customer_auth_token(id)
      params = {
        :customer_id => id
      }
      response = post('/customers/authenticate', params).to_hash
      response['auth_token']
    end

  end
end