require 'rails_helper'

RSpec.describe 'people', type: :request do
  it 'fails without authentication' do
    get events_path

    expect(response).to have_http_status(401)
  end

  it 'lists at /people' do
    get people_path, headers: default_headers
    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['people']).not_to be nil
  end

  it 'returns people for locale at /locales/{id}/people' do
    nyc = HotMessModels::Locale.find_by(label: 'nyc')

    get "/locales/#{nyc.id}/people", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['people']).not_to be nil
  end

  it 'returns person for locale at /people/{id}' do
    model = HotMessModels::Person.first

    get "/people/#{model.id}", params: default_params, headers: default_headers

    expect(response).to have_http_status(200)
    data = JSON.parse(response.body)

    expect(data['person']).not_to be nil
  end
end
