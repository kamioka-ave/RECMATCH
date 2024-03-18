class CreateInterviews < ActiveRecord::Migration[4.2]
  def change
    create_table :interviews do |t|
      t.integer :user_id
      t.integer :emphasis_company_rank
      t.integer :emphasis_company_elements, defaut: 0, null: false
      t.integer :emphasis_ceo_rank
      t.integer :emphasis_ceo_elements, defaut: 0, null: false
      t.integer :emphasis_position_rank
      t.integer :emphasis_position_elements, defaut: 0, null: false
      t.integer :emphasis_income_rank
      t.integer :emphasis_income_elements, defaut: 0, null: false
      t.integer :strategy
      t.string :strategy_company
      t.text :strategy_example
      t.text :strategy_point
      t.integer :decision
      t.string :decision_company
      t.text :decision_example
      t.text :decision_point
      t.integer :performance
      t.string :performance_company
      t.text :performance_example
      t.text :performance_point
      t.integer :presentation
      t.string :presentation_company
      t.text :presentation_example
      t.text :presentation_point
      t.integer :leadership
      t.string :leadership_company
      t.text :leadership_example
      t.text :leadership_point
      t.integer :creativity
      t.string :creativity_company
      t.text :creativity_example
      t.text :creativity_point
      t.integer :stance
      t.string :stance_company
      t.text :stance_example
      t.text :stance_point
      t.integer :attitude
      t.string :attitude_company
      t.text :attitude_example
      t.text :attitude_point
      t.integer :time
      t.string :time_company
      t.text :time_example
      t.text :time_point
      t.integer :information
      t.string :information_company
      t.text :information_example
      t.text :information_point

      t.timestamps null: false
    end
  end
end
