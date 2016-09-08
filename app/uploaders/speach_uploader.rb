class SpeachUploader < CarrierWave::Uploader::Base
  storage :fog

  def filename
    @name ||= "#{Date.today.to_s(:number)}-#{super}" if original_filename.present?
  end

  def extension_whitelist
    %w(flac wav)
  end
end
