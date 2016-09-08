class UploadsController < ApplicationController
  def new
  end

  def create
    @file     = params[:sound]
    @uploader = SpeachUploader.new
    result = @uploader.store!(@file)
    SpeachToTextWorker.perform_async(@uploader.filename, params[:speaker])
    redirect_to new_upload_path, notice: 'File uploaded successfully.'
  end
end
