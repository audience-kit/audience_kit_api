# frozen_string_literal: true

class TracksController < ApplicationController
  skip_before_action :authenticate, only: [ :waveform, :artwork ]

  def show
    @track = Track.find(params[:id])

    render json: @track.metadata
  end

  def waveform
    @track = Track.find(params[:id])
    redirect_to url_for(@track.waveform_photo)
  end

  def artwork
    @track = Track.find(params[:id])
    redirect_to url_for(@track.photo)
  end
end