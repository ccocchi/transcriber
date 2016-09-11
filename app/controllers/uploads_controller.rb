class UploadsController < ApplicationController
  def new
  end

  def create
    @file     = params[:sound]
    @uploader = SpeachUploader.new
    result = @uploader.store!(@file)
    speach = Speach.new(speaker: params[:speaker], filename: @uploader.filename, tags: params[:tags])
    if speach.save
      SpeachToTextWorker.perform_async(speach.id)
      redirect_to new_upload_path, notice: 'File uploaded successfully.'
    else
      redirect_to new_upload_path, notice: 'Something went wrong, my bad.'
    end
  end
end
