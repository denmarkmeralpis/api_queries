require 'spec_helper'
require 'db/helper'

RSpec.describe ApiQueries do
  let(:data) do
    User.create(updated_at: '2018-07-20T00:00:00Z', created_at: '2018-07-20T00:00:00Z', status: 'active')
    User.create(updated_at: '2018-07-21T00:00:00Z', created_at: '2018-07-21T00:00:00Z', status: 'deleted')
    User.create(updated_at: '2018-07-22T00:00:00Z', created_at: '2018-07-22T00:00:00Z', status: 'active')
  end

  context '#api_q' do
    it 'returns nil if no record found q=last_updated_at' do
      expect(User.api_q(q: 'last_updated_at')[:last_updated_at]).to eq(nil)
    end

    it 'should not return nil it has record' do
      data
      expect(User.api_q(q: 'last_updated_at')[:last_updated_at]).not_to eq(nil)
    end

    it 'returns record count' do
      expect(User.api_q(q: 'count')[:count]).to eq(3)
    end

    it 'returns records where updated_at > given_date' do
      expect(User.api_q(after: '2018-07-19T00:00:00Z').count).to eq(3)
      expect(User.api_q(after: '2018-07-20T00:00:00Z').count).to eq(2)
      expect(User.api_q(after: '2018-07-21T00:00:00Z').count).to eq(1)
      expect(User.api_q(after: '2018-07-22T00:00:00Z').count).to eq(0)
      expect(User.api_q(after: '2018-07-19T00:00:00Z', active_only: '1').count).to eq(2)
      expect(User.api_q(after: '2018-07-19T00:00:00Z', active_only: '1', q: 'count')[:count]).to eq(2)
    end

    it 'returns records where updated_at < given_date' do
      expect(User.api_q(before: '2018-07-20T00:00:00Z').count).to eq(0)
      expect(User.api_q(before: '2018-07-21T00:00:00Z').count).to eq(1)
      expect(User.api_q(before: '2018-07-22T00:00:00Z').count).to eq(2)
      expect(User.api_q(before: '2018-07-23T00:00:00Z').count).to eq(3)
      expect(User.api_q(before: '2018-07-23T00:00:00Z', active_only: '1').count).to eq(2)
      expect(User.api_q(before: '2018-07-23T00:00:00Z', active_only: '1', q: 'count')[:count]).to eq(2)
    end

    it 'returns records between specified dates' do
      expect(User.api_q(from: '2018-07-20T00:00:00Z', to: '2018-07-20T00:00:00Z').count).to eq(1)
      expect(User.api_q(from: '2018-07-20T00:00:00Z', to: '2018-07-21T00:00:00Z').count).to eq(2)
      expect(User.api_q(from: '2018-07-20T00:00:00Z', to: '2018-07-22T00:00:00Z').count).to eq(3)
      expect(User.api_q(from: '2018-07-20T00:00:00Z', to: '2018-07-22T00:00:00Z', q: 'count')[:count]).to eq(3)
      expect(User.api_q(from: '2018-07-20T00:00:00Z', to: '2018-07-22T00:00:00Z', active_only: '1', q: 'count')[:count]).to eq(2)
    end

    it 'returns records where updated_at >= given_date' do
      expect(User.api_q(from: '2018-07-20T00:00:00Z').count).to eq(3)
      expect(User.api_q(from: '2018-07-21T00:00:00Z').count).to eq(2)
      expect(User.api_q(from: '2018-07-22T00:00:00Z').count).to eq(1)
      expect(User.api_q(from: '2018-07-23T00:00:00Z').count).to eq(0)
      expect(User.api_q(from: '2018-07-20T00:00:00Z', active_only: '1').count).to eq(2)
      expect(User.api_q(from: '2018-07-20T00:00:00Z', active_only: '1', q: 'count')[:count]).to eq(2)
    end

    it 'returns records where updated_at <= given_date' do
      expect(User.api_q(to: '2018-07-20T00:00:00Z').count).to eq(1)
      expect(User.api_q(to: '2018-07-21T00:00:00Z').count).to eq(2)
      expect(User.api_q(to: '2018-07-22T00:00:00Z').count).to eq(3)
      expect(User.api_q(to: '2018-07-20T00:00:00Z', active_only: '1').count).to eq(1)
      expect(User.api_q(to: '2018-07-20T00:00:00Z', active_only: '1', q: 'count')[:count]).to eq(1)
    end

    it 'raises exception if column_date is invalid' do
      expect { User.api_q(q: 'count', column_date: 'non-existent column') }.to raise_error(ApiQueries::Errors::UnknownColumn)
    end
  end
end
