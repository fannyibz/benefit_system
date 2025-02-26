class CreateRules < ActiveRecord::Migration[7.0]
  def change
    create_table :rules do |t|
      t.string :name
      t.integer :amount
      t.jsonb :conditions, default: {}
      t.references :benefit, foreign_key: true

      t.timestamps
    end
  end
end 