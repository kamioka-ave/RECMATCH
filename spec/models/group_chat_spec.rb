require 'rails_helper'

RSpec.describe GroupChat, type: :model do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:messages) }
  end
end
