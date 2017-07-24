FactoryGirl.define do
  factory :activity, aliases: [:qualifying_activity] do
    sequence(:strava_id)
    started_at 1.hour.ago
    strava_type 'Run'
    distance_in_meters 42
    moving_time_in_seconds 630
    average_heart_rate 91

    factory :unqualifyng_activity do
      moving_time_in_seconds 500
    end
  end
end
