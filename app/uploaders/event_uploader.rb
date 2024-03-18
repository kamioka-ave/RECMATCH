class EventUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  process :resize_to_limit => [1024, 1024]

  version :thumb do
    process :resize_to_fill => [512, 512]
  end

  version :thumb16by9 do
    process :resize_to_fill => [512, 288]
  end

  version :thumb4by3 do
    process :resize_to_fill => [512, 384]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
end
