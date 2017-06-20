class Activity < ActiveRecord::Base
  validates :strava_id, :started_at, :strava_type, :distance_in_meters,
            :moving_time_in_seconds, presence: true
  validates :strava_id, uniqueness: true

  scope :qualifying, -> { where(['moving_time_in_seconds > ?', 600]) }
end
