# coding: utf-8
FactoryBot.define do
  factory :company do
    name 'テスト株式会社'
    name_kana 'テストカブシキガイシャ'
    website 'http://example.com'
    president_first_name 'MyString'
    president_last_name 'MyString'
    president_first_name_kana 'MyString'
    president_last_name_kana 'MyString'
    president_birth_on '1990-06-24'
    is_antisocial_check_passed true
    is_identification_passed true
    status Company::S_ACTIVE
    agree_use_group_chat true
    chat_toggle 1
  end
end
