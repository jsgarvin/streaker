class ActivityWeek
  attr_reader :date

  def initialize(date)
    @date = date
  end

  def active?
    active_days.count >= 2
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
      ActivityDay.new(date.beginning_of_week + x.days)
    end
  end
end
