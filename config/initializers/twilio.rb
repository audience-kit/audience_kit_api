
def send_text_message(text)
  begin
    client = Twilio::REST::Client.new 'AC5f75bb86a003e5cda83d9d7514de864b', Rails.application.secrets[:twilio_key]

    client.messages.create(
        from: '+14063154776',
        to: '+12069133215',
        body: "New User: #{u.first_name} #{u.last_name}"
    )
  rescue => ex
    Rails.logger.error ex
  end
end