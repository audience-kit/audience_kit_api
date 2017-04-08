class AlexaController < ApplicationController
  skip_before_action :authenticate

  def index
    @events = Event.future.take(3)

    render text: "The next few events are #{@events.map(&:to_english).to_sentence}"
  end
end