# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'events', type: :request do

  it 'fails without authentication' do
    get events_path

    expect(response).to have_http_status(401)
  end

  it 'returns events for locale at /locale/{id}/events' do
    nyc = Locale.find_by(label: 'nyc')

    get "/v1/locales/#{nyc.id}/events", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['events']).not_to be nil
  end
end
