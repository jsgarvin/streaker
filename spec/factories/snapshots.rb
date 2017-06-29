FactoryGirl.define do
  factory :snapshot, aliases: [:unnotified_snapshot] do
    shot_at Time.now

    factory :notified_snapshot do
      notified_at Time.now
    end
  end
end
