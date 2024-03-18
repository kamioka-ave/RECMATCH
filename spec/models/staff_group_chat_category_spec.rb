require 'rails_helper'

RSpec.describe StaffGroupChatCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:staff) }
    it { should belong_to(:group_chat_category) }
  end
end
