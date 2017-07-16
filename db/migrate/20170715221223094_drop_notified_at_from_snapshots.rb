class DropNotifiedAtFromSnapshots < ActiveRecord::Migration
  def change
    remove_column :snapshots, :notified_at, :datetime
  end
end
