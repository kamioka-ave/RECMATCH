class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.integer :project_draft_id
      t.integer :proposal_id
      t.integer :company_id
      t.string :name
      t.string :image
      t.string :interview_movie
      t.integer :status, null: false, default: 0
      t.string :president_image
      t.text :president_description
      t.string :short_description
      t.text :description, :limit => 0xffffff
      t.text :company_info, :limit => 0xffffff
      t.integer :number_hired
      t.integer :revision, null: false, default: 1
      t.text :salary
      t.text :process_selection
      t.text :selection_condition
      t.date :entry_closed
      t.text :student_assumption
      t.text :recruit_kind
      t.text :duty_station
      t.text :new_salary
      t.text :allowance
      t.text :raise_salary
      t.text :reward
      t.text :holiday
      t.text :insurance
      t.text :welfare_program
      t.text :company_event
      t.integer :sex_ratio
      t.text :trial_period
      t.text :other_welfare
      t.integer :retired_ratio
      t.integer :sex_ratio_hired
      t.integer :continuous
      t.integer :old
      t.text :training
      t.text :vacation
      t.text :childcare
      t.text :recruit_univ
      t.text :univ_depart
      t.date :start_at
      t.date :end_at

      t.timestamps null: false
    end
  end
end
