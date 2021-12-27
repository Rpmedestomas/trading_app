class CreateTradingHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :trading_histories do |t|

      t.timestamps
    end
  end
end
