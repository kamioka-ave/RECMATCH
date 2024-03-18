class IdentificationUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  def initialize(*)
    super
    self.fog_public = false
    self.fog_authenticated_url_expiration = 604800
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  process :convert => 'jpg'

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
end
