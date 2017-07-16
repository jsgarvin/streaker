FactoryGirl.define do
  factory :snapshot do
    shot_at Time.now
    active_days_in_a_row 0
    active_weeks_in_a_row 0
  end
end
