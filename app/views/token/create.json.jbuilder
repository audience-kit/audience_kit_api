# frozen_string_literal: true

json.token @token

json.access_token @token
json.refresh_token @token

json.user do
  json.id @user.id
  json.name @user.name
end