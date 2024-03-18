# logが書き込まれるファイルの設定
set :output, "log/constants.log"

# 開発環境or本番環境の設定
set :environment, :production

# 企業メール
every :monday, at: '14pm' do
  runner 'PickupStudentsToCompanyJob.perform_later'
end

# 学生メール
every :weekday, at: '10:00 am' do
  runner 'OfferToStudentJob.perform_later'
end