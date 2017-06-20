class AddSnapshotsTable < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.datetime :shot_at
      t.datetime :notified_at
      t.integer :active_days_in_a_row
      t.integer :active_days_in_last_month
      t.integer :active_days_in_last_quarter
      t.integer :active_days_in_last_year
      t.integer :active_days_in_last_three_years
      t.integer :active_days_in_last_five_years
      t.integer :active_weeks_in_a_row
      t.integer :active_weeks_in_last_month
      t.integer :active_weeks_in_last_quarter
      t.integer :active_weeks_in_last_year
      t.integer :active_weeks_in_last_three_years
      t.integer :active_weeks_in_last_five_years

      t.timestamps null: false
    end

    add_index :snapshots, :shot_at
    add_index :snapshots, :active_days_in_a_row
    add_index :snapshots, :active_days_in_last_month
    add_index :snapshots, :active_days_in_last_quarter
    add_index :snapshots, :active_days_in_last_year
    add_index :snapshots, :active_days_in_last_three_years
    add_index :snapshots, :active_days_in_last_five_years
    add_index :snapshots, :active_weeks_in_a_row
    add_index :snapshots, :active_weeks_in_last_month
    add_index :snapshots, :active_weeks_in_last_quarter
    add_index :snapshots, :active_weeks_in_last_year
    add_index :snapshots, :active_weeks_in_last_three_years
    add_index :snapshots, :active_weeks_in_last_five_years
  end
end
