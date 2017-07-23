class SnapshotCalculation
  attr_reader :at,
              :streak_constructor,
              :activity_day_constructor,
              :activity_week_constructor

  def initialize(at: Time.now,
                 streak_constructor: Streak,
                 activity_day_constructor: ActivityDay,
                 activity_week_constructor: ActivityWeek)
    @at = at
    @streak_constructor = streak_constructor
    @activity_day_constructor = activity_day_constructor
    @activity_week_constructor = activity_week_constructor
  end

  def save
    Streaker.logger.info("Saving SnapshotCalculation: #{self}")
    Snapshot.create(shot_at: at,
                    active_days_in_a_row: active_days_in_a_row,
                    active_days_in_last_month: active_days_in_last_month,
                    active_days_in_last_quarter: active_days_in_last_quarter,
                    active_days_in_last_year: active_days_in_last_year,
                    active_days_in_last_three_years: active_days_in_last_three_years,
                    active_days_in_last_five_years: active_days_in_last_five_years,
                    active_weeks_in_a_row: active_weeks_in_a_row,
                    active_weeks_in_last_month: active_weeks_in_last_month,
                    active_weeks_in_last_quarter: active_weeks_in_last_quarter,
                    active_weeks_in_last_year: active_weeks_in_last_year,
                    active_weeks_in_last_three_years: active_weeks_in_last_three_years,
                    active_weeks_in_last_five_years: active_weeks_in_last_five_years)
  end

  def active_days_in_a_row
    @active_days_in_a_row ||= streak.days.count
  end

  def active_days_in_last_month
    @active_days_in_last_month ||=
      active_days_between(at - (DAYS_IN_A_MONTH - 1).days, at)
  end

  def active_days_in_last_quarter
    @active_days_in_last_quarter ||=
      active_days_between(at - (DAYS_IN_A_QUARTER - 1).days, at)
  end

  def active_days_in_last_year
    @active_days_in_last_year ||=
      active_days_between(at - (DAYS_IN_A_YEAR - 1).days, at)
  end

  def active_days_in_last_three_years
    @active_days_in_last_three_years ||=
      active_days_between(at - (DAYS_IN_THREE_YEARS - 1).days, at)
  end

  def active_days_in_last_five_years
    @active_days_in_last_five_years ||=
      active_days_between(at - (DAYS_IN_FIVE_YEARS - 1).days, at)
  end

  def active_weeks_in_a_row
    @active_weeks_in_a_row ||= streak.weeks.count
  end

  def active_weeks_in_last_month
    @active_weeks_in_last_month ||=
      active_weeks_between(at - (WEEKS_IN_A_MONTH - 1).weeks, at)
  end

  def active_weeks_in_last_quarter
    @active_weeks_in_last_quarter ||=
      active_weeks_between(at - (WEEKS_IN_A_QUARTER - 1).weeks, at)
  end

  def active_weeks_in_last_year
    @active_weeks_in_last_year ||=
      active_weeks_between(at - (WEEKS_IN_A_YEAR - 1).weeks, at)
  end

  def active_weeks_in_last_three_years
    @active_weeks_in_last_three_years ||=
      active_weeks_between(at - (WEEKS_IN_THREE_YEARS - 1).weeks, at)
  end

  def active_weeks_in_last_five_years
    @active_weeks_in_last_five_years ||=
      active_weeks_between(at - (WEEKS_IN_FIVE_YEARS - 1).weeks, at)
  end

  private

  def streak
    @streak ||= streak_constructor.new(ending_on: at)
  end

  def active_days_between(start, stop)
    activity_day_constructor.wrap(start.to_date, stop.to_date).count(&:active?)
  end

  def active_weeks_between(start, stop)
    activity_week_constructor.wrap(start.to_date, stop.to_date).count(&:active?)
  end
end
