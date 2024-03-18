module ProfilesHelper
  def profile_image(profile, options = {})
    image_tag(profile_image_url(profile), options)
  end

  def profile_image_url(profile, user_connections=[])
    if profile&.image.blank?
      connection = user_connections.first || UserConnection.where(user_id: profile&.user_id).order(:rank).first
      if connection
        connection.image_url
      else
        image_path('profile-default.png')
      end
    else
      profile.image.thumb.url
    end
  end
end
