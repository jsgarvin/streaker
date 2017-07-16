class CreateNotificationsTable < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :payload_digest

      t.timestamps null: false
    end
  end
end
