require 'rails_helper'

RSpec.describe GroupChat::Category, type: :model do
  describe 'validations' do
    context 'with presence' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:icon) }
    end

    context "with length" do
      it { should validate_length_of(:name).is_at_most 50 }
    end
  end

  describe 'associations' do
    it { should have_many(:group_chats).with_foreign_key(:group_chat_category_id) }
    it { should have_many(:consultations).with_foreign_key(:group_chat_category_id) }
    it { should have_many(:supporters).through(:consultations) }
    it { should have_many(:companies).through(:consultations) }
  end
end
