class ChangeColumnHumidityToDecimal < ActiveRecord::Migration[5.0]
  def up
    change_column :measurements, :humidity, :decimal
  end
  def down
    change_column :measurements, :humidity, :integer
  end
end
