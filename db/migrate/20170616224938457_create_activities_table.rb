class CreateActivitiesTable < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :strava_id
      t.datetime :started_at
      t.string :strava_type
      t.decimal :distance_in_meters, precision: 8, scale: 1
      t.integer :moving_time_in_seconds

      t.timestamps null: false
    end

    add_index :activities, :strava_id
    add_index :activities, :started_at
  end
end
