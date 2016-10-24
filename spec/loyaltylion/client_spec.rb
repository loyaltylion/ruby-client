require 'spec_helper'

RSpec.describe LoyaltyLion::Client do
  describe '#initialize' do
    it 'can create a new client with token/secret' do
      client = LoyaltyLion::Client.new(:token => 'abc', :secret => '123')

      expect(client.token).to eq('abc')
      expect(client.secret).to eq('123')
    end
  end

  describe '#request' do
    let(:client) { LoyaltyLion::Client.new(:token => 'abc', :secret => '123') }

    context 'any request' do
      before do
        stub_request(:get, 'https://api.loyaltylion.com/v2/orders')
      end

      it 'makes request to specified endpoint' do
        client.request(:method => :get, :path => '/orders')
        expect(WebMock).to have_requested(:get, 'https://api.loyaltylion.com/v2/orders')
      end

      it 'authenticates with token/secret' do
        client.request(:method => :get, :path => '/orders')
        expect(WebMock).to have_requested(:get, 'https://api.loyaltylion.com/v2/orders').with(
          :basic_auth => %w(abc 123),
        )
      end

      it 'sets custom user agent' do
        client.request(:method => :get, :path => '/orders')
        expect(WebMock).to have_requested(:get, 'https://api.loyaltylion.com/v2/orders').with(
          :headers => {
            'user-agent' => 'LoyaltyLion Ruby v1.0.0',
          },
        )
      end
    end

    context 'when request has a body' do
      it 'sends body as JSON' do
        stub_request(:post, 'https://api.loyaltylion.com/v2/orders')
        client.request(:method => :post, :path => '/orders', :body => {
          :merchant_id => 'xe8ae3fe',
        })

        expect(WebMock).to have_requested(:post, 'https://api.loyaltylion.com/v2/orders').with(
          :headers => {
            'content-type' => 'application/json',
          },
          :body => JSON.generate(:merchant_id => 'xe8ae3fe'),
        )
      end
    end

    context 'when API returns a 5xx response' do
      it 'raises LoyaltyLion::ServerError' do
        (500..510).each do |status|
          stub_request(:get, 'https://api.loyaltylion.com/v2/orders').to_return(
            :status => status,
          )

          expect { client.request(:method => :get, :path => '/orders') }.
            to raise_error(LoyaltyLion::ServerError)
        end
      end
    end

    context 'when API returns a 4xx response' do
      it 'raises LoyaltyLion::ClientError' do
        (400..430).each do |status|
          stub_request(:get, 'https://api.loyaltylion.com/v2/orders').to_return(
            :status => status,
          )

          expect { client.request(:method => :get, :path => '/orders') }.
            to raise_error(LoyaltyLion::ClientError)
        end
      end
    end

    context 'when API returns any other response' do
      let(:body) do
        { 'customers' => [{ 'merchant_id' => '1001' }] }
      end

      it 'returns response body' do
        stub_request(:get, 'https://api.loyaltylion.com/v2/orders').to_return(
          :status => 200,
          :headers => { 'content-type' => 'application/json' },
          :body => JSON.generate(body),
        )

        expect(
          client.request(:method => :get, :path => '/orders'),
        ).to eql(body)
      end
    end
  end

  describe 'resources' do
    let(:client) { LoyaltyLion::Client.new(:token => 'abc', :secret => '123') }

    describe '#orders' do
      it 'returns an instance of LoyaltyLion::Order' do
        expect(client.orders).to be_instance_of(LoyaltyLion::Order)
      end

      describe '#create' do
        it 'makes request with order data' do
          stub_request(:post, 'https://api.loyaltylion.com/v2/orders')
          client.orders.create(:merchant_id => 'xe8ae3fe')

          expect(WebMock).to have_requested(:post, 'https://api.loyaltylion.com/v2/orders').with(
            :body => JSON.generate(:merchant_id => 'xe8ae3fe'),
          )
        end
      end

      describe '#update' do
        it 'makes request with order merchant_id and data' do
          stub_request(:put, 'https://api.loyaltylion.com/v2/orders/xe8ae3fe')
          client.orders.update('xe8ae3fe', :total_paid => '69.99')

          expect(WebMock).to have_requested(:put, 'https://api.loyaltylion.com/v2/orders/xe8ae3fe').
            with(
              :body => JSON.generate(:total_paid => '69.99'),
            )
        end
      end
    end

    describe '#activities' do
      it 'returns an instance of LoyaltyLion::Activity' do
        expect(client.activities).to be_instance_of(LoyaltyLion::Activity)
      end

      describe '#create' do
        it 'makes POST request with activity data' do
          stub_request(:post, 'https://api.loyaltylion.com/v2/activities')
          client.activities.create(:name => 'review', :merchant_id => 'abc')

          expect(WebMock).to have_requested(:post, 'https://api.loyaltylion.com/v2/activities').
            with(
              :body => JSON.generate(:name => 'review', :merchant_id => 'abc'),
            )
        end
      end

      describe '#update' do
        it 'makes request with activity name, merchant_id and data' do
          stub_request(:put, 'https://api.loyaltylion.com/v2/activities/review/abc1')
          client.activities.update('review', 'abc1', :state => 'approved')

          expect(WebMock).to have_requested(
            :put,
            'https://api.loyaltylion.com/v2/activities/review/abc1',
          ).with(
            :body => JSON.generate(:state => 'approved'),
          )
        end
      end

      describe '#approve' do
        it 'makes PUT request to approve activity' do
          stub_request(:put, 'https://api.loyaltylion.com/v2/activities/review/abc1')
          client.activities.approve('review', 'abc1')

          expect(WebMock).to have_requested(
            :put,
            'https://api.loyaltylion.com/v2/activities/review/abc1',
          ).with(
            :body => JSON.generate(:state => 'approved'),
          )
        end
      end

      describe '#decline' do
        it 'makes PUT request to decline activity' do
          stub_request(:put, 'https://api.loyaltylion.com/v2/activities/review/abc1')
          client.activities.decline('review', 'abc1')

          expect(WebMock).to have_requested(
            :put,
            'https://api.loyaltylion.com/v2/activities/review/abc1',
          ).with(
            :body => JSON.generate(:state => 'declined'),
          )
        end
      end
    end
  end
end
