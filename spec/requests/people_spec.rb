# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people', type: :request do
  it 'fails without authentication' do
    get events_path

    expect(response).to have_http_status(401)
  end

  it 'returns people for locale at /locales/{id}/people' do
    nyc = Locale.find_by(label: 'nyc')

    get "/locales/#{nyc.id}/people", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['people']).not_to be nil
  end

  it 'returns person for locale at /people/{id}' do
    model = Person.first

    get "/people/#{model.id}", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['person']).not_to be nil
  end

  it 'returns tracks for a person who is a DJ' do
    model = Person.joins(:page).find_by(pages: { name: 'DUGAN' })

    get "/people/#{model.id}", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['person']['tracks'].count).not_to be 0
  end

  it 'returns social media links' do
    model = Person.joins(:page).find_by(pages: { name: 'Drew G' })

    get "/people/#{model.id}", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['person']['social_links'].count).not_to eq 0
  end

  it 'should have a picture' do
    model = Person.joins(:page).find_by(pages: { name: 'Drew G' })

    get "/people/#{model.id}", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['person']['photo_url']).to eq 'https://cdn.hotmess.social/bYqVDHFKrFvDRdzvgkLSTzw1MGo'
  end

  it 'should have a cover' do
    model = Person.joins(:page).find_by(pages: { name: 'Drew G' })

    get "/people/#{model.id}", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['person']['cover_url']).to eq 'https://cdn.hotmess.social/RHJOedzQEIi3Gt6yo6tR8r3YpfA'
  end
end
