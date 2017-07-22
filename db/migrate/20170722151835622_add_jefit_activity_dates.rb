class AddJefitActivityDates < ActiveRecord::Migration
  def change
    create_table :jefit_activity_dates do |t|
      t.date :active_on
      t.timestamps
    end

    add_index :jefit_activity_dates, :active_on
  end
end
