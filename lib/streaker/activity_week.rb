class ActivityWeek
  attr_reader :date, :day_constructor

  def self.wrap(start, stop)
    zone_start = start.in_time_zone(Streaker.config.time_zone).to_date
    zone_stop = stop.in_time_zone(Streaker.config.time_zone).to_date
    mondays = (zone_start.beginning_of_week..zone_stop).each_slice(7)
                                                       .map(&:first)
    mondays.map { |monday| ActivityWeek.new(monday) }
  end

  def initialize(date, day_constructor: ActivityDay)
    @date = date
    @day_constructor = day_constructor
  end

  def active?
    active_days.count >= 5 && jefit_activity_dates.count >= 2
  end

  def previous
    ActivityWeek.new(date - 1.week)
  end

  private

  def active_days
    activity_days.select(&:active?)
  end

  def activity_days
    (0..6).map do |x|
      day_constructor.new(date.beginning_of_week + x.days)
    end
  end

  def jefit_activity_dates
    JefitActivityDate.where(
      active_on: date.beginning_of_week.to_date..date.end_of_week.to_date
    )
  end
end
