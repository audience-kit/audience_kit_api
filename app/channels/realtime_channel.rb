# frozen_string_literal: true

class RealtimeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:venue_id]}"
  end

  def receive(data)
    Rails.logger.info "RealtimeChannel#receive => #{data}"

    data['type'] = 'incoming'

    ActionCable.server.broadcast("chat_#{params[:venue_id]}", data)
  end
end
