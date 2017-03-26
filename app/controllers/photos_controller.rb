class PhotosController < ApplicationController
  skip_before_filter :authenticate

  def show
    @photo = HotMessModels::Photo.find(params[:id])

    return render status: :not_found unless @photo

    response.headers['ETag'] = Base64.encode64 @photo.content_hash
    response.headers['Expires'] = 1.day.from_now.httpdate

    send_data @photo.content, type: @photo.mime
  end
end