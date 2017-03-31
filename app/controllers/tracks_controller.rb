class TracksController < ApplicationController
  skip_before_action :authenticate, only: [ :waveform, :artwork ]

  def show
    @track = HotMessModels::Track.find(params[:id])

    render json: @track.metadata
  end

  def waveform
    @track = HotMessModels::Track.find(params[:id])
    redirect_to url_for(@track.waveform_photo)
  end

  def artwork
    @track = HotMessModels::Track.find(params[:id])
    redirect_to url_for(@track.photo)
  end
end