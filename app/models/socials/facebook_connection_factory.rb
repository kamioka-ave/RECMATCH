class FacebookConnectionFactory
  def self.create(auth, rank, user_id = 0)
    UserConnection.new(
      access_token: auth.credentials.token,
      display_name: auth.info.name,
      expire_time: Time.at(auth.credentials.expires_at).to_s(:db),
      image_url: auth.info.image,
      profile_url: auth.extra.raw_info.link,
      provider_id: auth.provider,
      provider_user_id: auth.uid,
      rank: rank,
      refresh_token: '',  # TODO
      secret: auth.credentials.secret,
      user_id: user_id,
      link: "https://www.facebook.com/#{auth.uid}"
    )
  end
end
