class ActsAsVotableMigration < ActiveRecord::Migration[4.2]
  def self.up
    create_table :votes do |t|

      t.references :votable, :polymorphic => true
      t.references :voter, :polymorphic => true

      t.boolean :vote_flag
      t.string :vote_scope
      t.integer :vote_weight

      t.timestamps
    end

    if ActiveRecord::VERSION::MAJOR < 4
      add_index :votes, [:votable_id, :votable_type]
      add_index :votes, [:voter_id, :voter_type]
    end

    add_index :votes, [:voter_id, :voter_type, :vote_scope]
    add_index :votes, [:votable_id, :votable_type, :vote_scope]

    add_column :comments, :cached_votes_up, :integer, default: 0
  end

  def self.down
    drop_table :votes

    remove_column :comments, :cached_votes_up
  end
end
