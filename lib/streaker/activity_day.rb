class ActivityDay
  attr_reader :date

  def self.wrap(start, stop)
    zone_start = start.in_time_zone(Streaker.config.time_zone).to_date
    zone_stop = stop.in_time_zone(Streaker.config.time_zone).to_date
    (zone_start..zone_stop).map { |date| ActivityDay.new(date) }
  end

  def initialize(date)
    @date = date.in_time_zone(Streaker.config.time_zone).to_date
  end

  def active?
    activities_on_date.any? || jefit_activity_date_on_date
  end

  def previous
    ActivityDay.new(date - 1.day)
  end

  private

  def activities_on_date
    Activity.qualifying
            .where(['started_at BETWEEN ? AND ?',
                    date.beginning_of_day,
                    date.end_of_day])
  end

  def jefit_activity_date_on_date
    JefitActivityDate.find_by(active_on: date)
  end
end
