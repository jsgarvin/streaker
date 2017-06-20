class Streak
  attr_reader :end_date

  def initialize(ending_on:)
    @end_date = ending_on
  end

  def days
    @days ||= units(:days)
  end

  def weeks
    @weeks ||= units(:weeks)
  end

  private

  def units(name)
    klass = "Activity#{name.to_s.singularize.titleize}".constantize
    Array.new.tap do |units|
      activity_unit = klass.new(end_date)
      while activity_unit.active?
        units  << activity_unit
        activity_unit = activity_unit.previous
      end
    end
  end
end
