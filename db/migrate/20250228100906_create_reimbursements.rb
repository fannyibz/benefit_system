class CreateReimbursements < ActiveRecord::Migration[8.0]
  def change
    create_table :reimbursements do |t|
      t.references :user_benefit, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :amount, null: false
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
