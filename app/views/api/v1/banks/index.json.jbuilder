json.array!(@banks) do |bank|
  json.extract! bank, :id, :kana, :hiragana, :is_popular
  json.name bank.name_with_bank
end
