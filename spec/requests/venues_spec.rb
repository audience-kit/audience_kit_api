require 'rails_helper'

RSpec.describe 'venues', type: :request do
  it 'fails without authentication' do
    get events_path

    expect(response).to have_http_status(401)
  end

  it 'lists at /venues' do
    get venues_path, headers: default_headers
    expect(response).to have_http_status(200)
  end

  it 'returns a venue at /venues/closest' do
    get '/venues/closest', params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['venue']).not_to be nil
  end

  it 'returns venues for locale at /locales/{id}/venues' do
    nyc = HotMessModels::Locale.find_by(label: 'nyc')

    get "/locales/#{nyc.id}/venues", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['venues']).not_to be nil
  end

  it 'returns venue for locale at /venues/{id}' do
    nyc = HotMessModels::Locale.find_by(label: 'nyc')

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
    nyc = HotMessModels::Locale.find_by(label: 'nyc')

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
