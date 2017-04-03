class PhotosController < ApplicationController
  skip_before_action :authenticate

  def show
    @photo = Photo.find(params[:id])

    return render status: :not_found unless @photo

    redirect_to @photo.cdn_url
  end
end