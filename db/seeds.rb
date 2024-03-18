# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Country.delete_all
CSV.foreach('db/csv/countries.csv').with_index(1) do |row, i|
  Country.create!(
    id: i,
    name: row[0],
    name_en: row[1],
    code: row[2],
    code_ja: row[3],
    code_string3: row[4],
    code_string2: row[5]
  )
end
