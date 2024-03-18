namespace :company do
  task recreate_thumbnails: :environment do
    Company.all.each do |c|
      if c.image.present?
        c.image.recreate_versions!
        c.save!(validate: false)
      end
    end
  end
end