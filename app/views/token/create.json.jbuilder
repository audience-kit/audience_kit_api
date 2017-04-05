# frozen_string_literal: true

json.token @token

json.user do
  json.id @user.id
  json.name @user.name
end