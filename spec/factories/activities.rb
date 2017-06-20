FactoryGirl.define do
  factory :activity do
    sequence(:strava_id)
    started_at 1.hour.ago
    strava_type 'Run'
    distance_in_meters 42
    moving_time_in_seconds 630
  end
end
