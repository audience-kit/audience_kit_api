Yelp.client.configure do |config|
  yelp_secrets = Rails.application.secrets['yelp']

  config.consumer_key = yelp_secrets['consumer_key']
  config.consumer_secret = yelp_secrets['consumer_secret']
  config.token = yelp_secrets['token']
  config.token_secret = yelp_secrets['token_secret']
end