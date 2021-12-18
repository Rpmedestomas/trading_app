class UserStatusDefaultPending < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :money, :float, :default => 0.00
  end
end
