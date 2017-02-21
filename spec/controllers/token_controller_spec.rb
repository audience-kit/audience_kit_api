require 'rails_helper'

RSpec.describe TokenController, type: :controller do

  it "should not require authentication"
  it "should return a token for a valid facebook token"
  it "should not return a valid token for an invalid facebook token"
  it "should set the token as administrative when the user is administrative"
end
