class AddFiledsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :start_date, :date
    add_column :users, :location, :string
    add_column :users, :contract_type, :string
  end
end
