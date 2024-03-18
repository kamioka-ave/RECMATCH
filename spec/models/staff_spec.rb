require 'rails_helper'

RSpec.describe Staff, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:company) }
  end

  describe 'validations' do
    context 'with presence' do
      it { is_expected.to validate_presence_of :first_name }
      it { is_expected.to validate_presence_of :last_name }
      it { is_expected.to validate_presence_of :first_name_kana }
      it { is_expected.to validate_presence_of :last_name_kana }
    end

    context 'with length' do
      it { is_expected.to validate_length_of(:first_name).is_at_most 255 }
      it { is_expected.to validate_length_of(:last_name).is_at_most 255 }
      it { is_expected.to validate_length_of(:first_name_kana).is_at_most 255 }
      it { is_expected.to validate_length_of(:last_name_kana).is_at_most 255 }
    end
  end

  describe '#full_name' do
    subject { create(:staff, first_name: 'test', last_name: 'name', user: nil) }

    it { expect(subject.full_name).to eq 'nametest' }
  end

  describe '#strip_name' do
    subject { create(:staff, first_name: ' test ', last_name: ' name ', user: nil) }

    it "should strip name" do
      expect(subject.first_name).to eq 'test'
      expect(subject.last_name).to eq 'name'
    end
  end
end
