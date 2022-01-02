class CreateTradingHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :trading_histories do |t|
      t.string :name
      t.integer :price
      t.integer :quantity
      t.string :transaction_type  

      t.timestamps
    end
  end
end
