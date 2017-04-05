# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'venues', type: :request do
  describe 'now' do
    describe 'locale' do
      SPOKANE_POINT = { longitude: '-117', latitude: '47' }.freeze

      before :each do
        get '/now', params: SPOKANE_POINT.dup, headers: default_headers
        expect(response).to have_http_status(200)

        @data = JSON.parse(response.body)
      end

      it 'should return a locale when not in a venue' do
        expect(@data['venue']).to be_nil
        expect(@data['venues']).not_to be_nil
        expect(@data['locale']).not_to be_nil
        expect(@data['events']).not_to be_nil
      end

      it 'should have a photo when not in a venue' do
        expect(@data['image_url']).to eq 'https://cdn.hotmess.social/bvmajHp6gqw0ICpV-txYtBkCPA8'
      end
    end

    describe 'venue' do
      SPOKANE_NYNE_POINT = { longitude: '-117.414777', latitude: '47.6575451' }.freeze

      before :each do
        get '/now', params: SPOKANE_NYNE_POINT.dup, headers: default_headers
        expect(response).to have_http_status(200)

        @data = JSON.parse(response.body)
      end

      it 'should return a venue when in a venue' do
        expect(@data['venue']).not_to be_nil
        expect(@data['venues']).to be_nil
        expect(@data['locale']).not_to be_nil
        expect(@data['events']).not_to be_nil
      end

      it 'should return a friend if they checked in recently'

      it 'should have a photo for a venue' do
        expect(@data['image_url']).to eq 'https://cdn.hotmess.social/nF9pK74Uf699JAM5XqYgNFDgDPU'
      end
    end
  end

  it 'fails without authentication' do
    get events_path

    expect(response).to have_http_status(401)
  end

  it 'lists at /venues' do
    get locale_venues_path(Locale.find_by(label: 'nyc')), headers: default_headers
    expect(response).to have_http_status(200)
  end

  it 'returns a venue at /venues/closest' do
    get '/venues/closest', params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['venue']).not_to be nil
  end

  it 'returns a venue at /now when in venue' do
    get '/now', params: { longitude: '-117.1605916', latitude: '32.743582' }, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['venue']).not_to be nil
  end

  it 'returns venues for locale at /locales/{id}/venues' do
    nyc = Locale.find_by(label: 'nyc')

    get "/locales/#{nyc.id}/venues", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['venues']).not_to be nil
  end

  it 'returns venue for locale at /venues/{id}' do
    nyc = Locale.find_by(label: 'nyc')

    get "/locales/#{nyc.id}/venues", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['venues']).not_to be nil
    venue = data['venues'].first

    get "/venues/#{venue['id']}", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['venue']).not_to be nil
  end

  it 'returns events for locale at /venues/{id}/events' do
    nyc = Locale.find_by(label: 'nyc')

    get "/locales/#{nyc.id}/venues", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['venues']).not_to be nil
    venue = data['venues'].first

    get "/venues/#{venue['id']}/events", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['events']).not_to be nil
  end
end
