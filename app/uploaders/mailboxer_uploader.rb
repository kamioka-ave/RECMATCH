class MailboxerUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  process :resize_to_fill => [800, 800]

  version :thumb do
    process :resize_to_fill => [192, 192]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
end
