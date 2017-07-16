class SnapshotCalculation
  attr_reader :at

  def initialize(at: Time.now)
    @at = at
  end

  def save
    Streaker.logger.info("Saving SnapshotCalculation: #{self}")
    Snapshot.create(shot_at: at,
                    active_days_in_a_row: active_days_in_a_row,
                    active_weeks_in_a_row: active_weeks_in_a_row)
  end

  def active_days_in_a_row
    @active_days_in_a_row ||= calculated_active_days_in_a_row
  end

  def active_weeks_in_a_row
    @active_weeks_in_a_row ||= calculated_active_weeks_in_a_row
  end

  private

  def calculated_active_days_in_a_row
    streak.days.count
  end

  def calculated_active_weeks_in_a_row
    streak.weeks.count
  end

  def streak
    @streak ||= Streak.new(ending_on: at)
  end
end
