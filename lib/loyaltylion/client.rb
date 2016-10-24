require 'httparty'
require 'json'
require 'loyaltylion/version'
require 'loyaltylion/errors'

module LoyaltyLion
  class Client
    include HTTParty
    base_uri 'https://api.loyaltylion.com/v2'

    attr_reader :token, :secret

    def initialize(opts = {})
      @token = opts[:token]
      @secret = opts[:secret]
    end

    def orders
      LoyaltyLion::Order.new(self)
    end

    def activities
      LoyaltyLion::Activity.new(self)
    end

    def request(opts)
      method = opts[:method] || :get
      path = opts[:path]
      body = opts[:body] || {}
      headers = {
        'user-agent' => "LoyaltyLion Ruby v#{LoyaltyLion::VERSION}",
      }

      unless body.empty?
        headers['content-type'] = 'application/json'
        body = JSON.generate(body)
      end

      res = self.class.send(method, path,
        :basic_auth => {
          :username => token,
          :password => secret,
        },
        :headers => headers,
        :body => body.empty? ? nil : body
      )

      if res.code >= 200 && res.code < 300
        res.parsed_response
      elsif res.code >= 400 && res.code < 500
        raise LoyaltyLion::ClientError, res.parsed_response.inspect
      else
        raise LoyaltyLion::ServerError, res.parsed_response.inspect
      end
    end
  end
end
