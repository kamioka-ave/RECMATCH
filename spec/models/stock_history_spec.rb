require 'rails_helper'

RSpec.describe StockHistory, type: :model do
  context 'validations' do
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:partition_number) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:partition_number).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
  end
end
