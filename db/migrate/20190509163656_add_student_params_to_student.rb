class AddStudentParamsToStudent < ActiveRecord::Migration[5.2]
  def up
    add_column :students, :club, :text, after: :qualifications
    add_column :students, :jobhuntingaxis, :integer, after: :qualifications
    add_column :students, :jobhuntingaxis_text, :string, after: :qualifications
    add_column :students, :seminar, :string, after: :qualifications
    add_column :students, :circle, :string, after: :qualifications
    add_column :students, :mypr, :text, after: :qualifications
  end

  def down
    remove_column :students, :club, :text
    remove_column :students, :jobhuntingaxis, :integer
    remove_column :students, :jobhuntingaxis_text, :string
    remove_column :students, :seminar, :string
    remove_column :students, :circle, :string
    remove_column :students, :mypr, :text
  end
end
