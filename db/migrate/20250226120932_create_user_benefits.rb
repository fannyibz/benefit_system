class CreateUserBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :user_benefits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :benefit, null: false, foreign_key: true
      t.references :rule, null: false, foreign_key: true
      t.integer :amount, null: false
      t.integer :status, default: 0
      t.datetime :granted_at
      t.datetime :consumed_at

      t.timestamps
    end

    add_index :user_benefits, [:user_id, :benefit_id, :created_at]
  end
end 