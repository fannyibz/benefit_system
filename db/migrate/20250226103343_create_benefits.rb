class CreateBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :benefits do |t|
      t.string :name
      t.integer :recurrence, default: 0
      t.timestamps
    end
  end
end 