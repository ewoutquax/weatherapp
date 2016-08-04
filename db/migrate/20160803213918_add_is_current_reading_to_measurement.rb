class AddIsCurrentReadingToMeasurement < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :is_current_reading, :boolean, default: false
  end
end
