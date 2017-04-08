class AlexaController < ApplicationController
  skip_before_action :authenticate

  def index
    render text: 'Hello from rails'
  end
end