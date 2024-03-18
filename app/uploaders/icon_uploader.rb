class IconUploader < ApplicationUploader
  def size_range
    0..10.megabytes
  end

  def extension_whitelist
    %w(jpg jpeg gif png svg)
  end
end
