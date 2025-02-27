class AddAmounToGrantToUserBenefit < ActiveRecord::Migration[8.0]
  def change
    add_column :user_benefits, :amount_to_grant, :integer, default: 0
  end
end
