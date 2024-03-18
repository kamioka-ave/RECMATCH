class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.integer :question_draft_id
      t.integer :question_category_id
      t.string :name
      t.text :asking
      t.text :answer
      t.integer :rank, default: 0, null: false

      t.integer :impressions_count, default: 0
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
      t.integer :cached_votes_up, default: 0
      t.integer :cached_votes_down, default: 0
      t.integer :cached_weighted_score, default: 0
      t.integer :cached_weighted_total, default: 0
      t.float :cached_weighted_average, default: 0.0

      t.timestamps
    end

    add_index :questions, :cached_votes_total
    add_index :questions, :cached_votes_score
    add_index :questions, :cached_votes_up
    add_index :questions, :cached_votes_down
    add_index :questions, :cached_weighted_score
    add_index :questions, :cached_weighted_total
    add_index :questions, :cached_weighted_average
  end
end
