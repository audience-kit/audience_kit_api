TWILIO_CLIENT = Twilio::REST::Client.new 'SKd159d345d4c433bd4392c22a4f79b41c', Rails.application.secrets[:twilio_key]

def send_text_message(text)
  begin
    TWILIO_CLIENT.messages.create(
        from: '+14063154776',
        to: '+12069133215',
        body: "New User: #{u.first_name} #{u.last_name}"
    )
  rescue => ex
    logger.error ex
  end
end