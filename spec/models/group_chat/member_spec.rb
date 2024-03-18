require 'rails_helper'

RSpec.describe GroupChat::Member, type: :model do
  context "validations" do
    it { should belong_to(:member)}
    it { should belong_to(:group_chat) }
  end
end
