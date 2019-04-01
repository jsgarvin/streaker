class ConvertStravaIdToBigint < ActiveRecord::Migration
  def up
    change_column :activities, :strava_id, :integer, limit: 8
  end

  def down
    change_column :activities, :strava_id, :integer
  end
end
