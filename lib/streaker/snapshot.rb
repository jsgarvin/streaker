class Snapshot < ActiveRecord::Base
  validates :active_days_in_a_row, :active_weeks_in_a_row, presence: true

  def active_days_in_a_row_with_fallback
    return active_days_in_a_row if active_days_in_a_row > 0
    Snapshot.where(['shot_at >= ?', previous_day.beginning_of_day])
            .maximum(:active_days_in_a_row)
  end

  def active_weeks_in_a_row_with_fallback
    return active_weeks_in_a_row if active_weeks_in_a_row > 0
    Snapshot.where(['shot_at >= ?', previous_week.beginning_of_week])
            .maximum(:active_weeks_in_a_row)
  end

  private

  def previous_day
    @previous_day ||= shot_at - 1.day
  end

  def previous_week
    @previous_week ||= shot_at - 1.week
  end
end
