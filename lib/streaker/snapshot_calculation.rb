class SnapshotCalculation
  attr_reader :at

  def initialize(at: Time.now)
    @at = at
  end

  def save
    Streaker.logger.info("Saving SnapshotCalculation: #{self}")
    Snapshot.create(shot_at: at,
                    active_days_in_a_row: active_days_in_a_row,
                    active_days_in_last_month: active_days_in_last_month,
                    active_weeks_in_a_row: active_weeks_in_a_row,
                    active_weeks_in_last_month: active_weeks_in_last_month)
  end

  def active_days_in_a_row
    @active_days_in_a_row ||= streak.days.count
  end

  def active_days_in_last_month
    @active_days_in_last_month ||= active_days_between(at - 30.days, at)
  end

  def active_weeks_in_a_row
    @active_weeks_in_a_row ||= streak.weeks.count
  end

  def active_weeks_in_last_month
    @active_weeks_in_last_month ||= active_weeks_between(at - 3.weeks, at)
  end

  private

  def streak
    @streak ||= Streak.new(ending_on: at)
  end

  def active_days_between(start, stop)
    zone_start = start.in_time_zone(Streaker.config.time_zone).to_date
    zone_stop = stop.in_time_zone(Streaker.config.time_zone).to_date
    (zone_start..zone_stop).count do |date|
      ActivityDay.new(date).active?
    end
  end

  def active_weeks_between(start, stop)
    zone_start = start.in_time_zone(Streaker.config.time_zone).to_date
    zone_stop = stop.in_time_zone(Streaker.config.time_zone).to_date
    mondays = (zone_start.beginning_of_week..zone_stop).each_slice(7)
                                                       .map(&:first)
    mondays.count do |date|
      ActivityWeek.new(date).active?
    end
  end
end
