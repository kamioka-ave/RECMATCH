json.array!(@bank_branches) do |branch|
  json.extract! branch, :id, :kana, :hiragana
  json.name branch.name_with_branch
end
