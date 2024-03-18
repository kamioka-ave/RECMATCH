class PrivateFileUploader < ApplicationUploader
  def initialize(*)
    super
    self.fog_public = false
    self.fog_authenticated_url_expiration = 604800
  end
end