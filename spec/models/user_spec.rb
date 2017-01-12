require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should load from a facebook model' do

    model = {"id": "10203595242113373",
             "link": "https://www.facebook.com/app_scoped_user_id/10203595242113373/",
             "name": "Richard Kenneth Mark",
             "email": "rickmark@outlook.com",
             "gender": "male",
             "locale": "en_US",
             "timezone": -8,
             "verified": true,
             "languages": [
                 {"id": "113301478683221", "name": "American English"},
                 {"id": "105673612800327", "name": "German"},
                 {"id": "103088979730830", "name": "Mandarin Chinese"},
                 {"id": "108083115891989", "name": "Português"},
                 {"id": "450169151702580", "name": "Portuguese"}],
             "last_name": "Mark",
             "first_name": "Richard",
             "middle_name": "Kenneth",
             "updated_time": "2016-05-13T13:46:14+0000",
             "favorite_teams": [
                 {"id": "646490315469630", "name": "Seattle Battalion"}],
             "favorite_athletes": [{"id": "40167009433", "name": "Ben Cohen"}]}

    user = User.from_facebook_graph model

    expect(user).not_to be_nil
  end
end
