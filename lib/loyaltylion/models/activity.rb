require 'loyaltylion/models/resource'

module LoyaltyLion
  class Activity < Resource
    def create(data)
      client.request(
        :method => :post,
        :path => '/activities',
        :body => data,
      )
    end

    def approve(name, merchant_id)
      update(name, merchant_id, :state => 'approved')
    end

    def decline(name, merchant_id)
      update(name, merchant_id, :state => 'declined')
    end

    def update(name, merchant_id, data)
      client.request(
        :method => :put,
        :path => "/activities/#{name}/#{merchant_id}",
        :body => data,
      )
    end
  end
end
