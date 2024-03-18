namespace :user do
  desc 'user tasks'

  task :create_account => :environment do
    User.all.each do |u|
      Account.create({user_id: u.id})
    end
  end
end