# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locales', type: :request do
  it 'fails without authentication' do
    get events_path

    expect(response).to have_http_status(401)
  end

  it 'lists at /locales' do
    get locales_path, headers: default_headers
    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['locales']).not_to be nil
  end

  it 'returns a locale at /locales/closest' do
    get '/v1/locales/closest', params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['locale']).not_to be nil
  end

  it 'returns locale for locale at /locale/{id}' do
    nyc = Locale.find_by(label: 'nyc')

    get '/v1/locales', params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['locales']).not_to be nil
    venue = data['locales'].first

    get "/v1/locales/#{venue['id']}", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['locale']).not_to be nil
  end
end
