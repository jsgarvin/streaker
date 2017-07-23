class ActivityWeek
  attr_reader :date, :day_constructor

  def initialize(date, day_constructor: ActivityDay)
    @date = date
    @day_constructor = day_constructor
  end

  def active?
    active_days.count >= 2 && jefit_activity_dates.count >= 2
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
    JefitActivityDate.where(active_on: date.beginning_of_week..date.end_of_week)
  end
end
