require 'rails_helper'

RSpec.describe Quit, type: :model do
  context 'quit!' do
    before(:each) do
      @user = FactoryBot.create(:student_user)
      FactoryBot.create(
        :quit_reason,
        id: 1,
        type: 'QuitReasonStudent',
        name: '魅力のあるプロジェクトがなかったから',
        rank: 10
      )
      FactoryBot.create(
        :quit_reason,
        id: 2,
        type: 'QuitReasonStudent',
        name: 'サービスやサイトが使いにくかったから',
        rank: 20
      )
      quit = Quit.new(
        note: '',
        quit_reason_ids: [1, 2]
      )
      quit.quit!(@user)
    end

    it 'OK' do
      user = User.find_by(id: @user.id)
      expect(user).to eq nil
    end
  end
end
