class TracksController < ApplicationController
  def show
    @track = HotMessModels::Track.find(params[:id])

    render json: @track.metadata
  end

  def waveform
    @track = HotMessModels::Track.find(params[:id])
    send_data @track.waveform_image, type: 'image/png'
  end

  def artwork
    @track = HotMessModels::Track.find(params[:id])
    send_data @track.artwork_image, type: 'image/jpeg'
  end
end