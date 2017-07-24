class AddHeartRateFieldsToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :average_heart_rate, :integer
    add_column :activities, :maximum_heart_rate, :integer
  end
end
