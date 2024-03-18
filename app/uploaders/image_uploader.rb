class ImageUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  process :resize_to_limit => [1920, 1920]

  version :thumb do
    process :resize_to_fill => [256, 256]
  end

  version :thumb16by9 do
    process :resize_to_fill => [512, 288]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
end
