require 'rails_helper'

RSpec.describe Company::Ir, type: :model do
  describe 'SES' do
    context 'Bounceを受信した場合' do
      before(:each) do
        json =<<EOS
{
  "Type" : "Notification",
  "MessageId" : "463fbb0b-63ea-4a6d-90c5-33c8686e3bd1",
  "TopicArn" : "arn:aws:sns:us-east-1:811118151095:suz-lab-ses",
  "Message" : {
      "notificationType":"Bounce",
      "bounce":{
         "bounceType":"Permanent",
         "bounceSubType": "General",
         "bouncedRecipients":[
            {
               "emailAddress":"student1@example.com"
            }
         ],
         "timestamp":"2018-11-02T20:09:38.237+09:00",
         "feedbackId":"00000137860315fd-869464a4-8680-4114-98d3-716fe35851f9-000000"
      },
      "mail":{
         "timestamp":"2018-11-02T20:09:38.237+09:00",
         "messageId":"00000137860315fd-34208509-5b74-41f3-95c5-22c1edc3c924-000000",
         "source":"email_1337983178237@amazon.com",
         "destination":[
            "student1@example.com"
         ]
      }
  }
}
EOS
        data = JSON.parse(json)
        student_user1 = FactoryBot.create(:student_user, email: 'student1@example.com')
        @message = FactoryBot.create(:ahoy_message, user: student_user1)
        @message.apply_ses_notification!(data['Message'])
      end

      it 'bounced_atに日時が入ること' do
        expect(@message.bounced_at).not_to eq nil
      end
    end
  end
end
