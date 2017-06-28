class ActivityDay
  attr_reader :date

  def initialize(date)
    @date = date.in_time_zone(Streaker.config.time_zone).to_date
  end

  def active?
    Activity.qualifying
            .where(['started_at BETWEEN ? AND ?',
                    date.beginning_of_day,
                    date.end_of_day])
            .any?
  end

  def previous
    ActivityDay.new(date - 1.day)
  end
end
