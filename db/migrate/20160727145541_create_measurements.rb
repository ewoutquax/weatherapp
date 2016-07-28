class CreateMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :measurements do |t|
      t.timestamp :measured_at
      t.decimal :temperature
      t.integer :pressure
      t.integer :humidity

      t.timestamps
    end
  end
end
