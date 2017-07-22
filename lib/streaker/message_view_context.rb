class MessageViewContext
  attr_reader :snapshot

  delegate :active_days_in_a_row_with_fallback,
           :active_weeks_in_a_row_with_fallback,
           to: :snapshot

  def initialize(snapshot:)
    @snapshot = snapshot
  end

  def get_binding
    binding
  end

  def percent_active_in_last(units, range)
    percent(active_in_last(units, range) / units_in_range(units, range))
  end

  def active_in_last(units, range)
    snapshot.send("active_#{units}_in_last_#{range}").to_i
  end

  def record_active_days_in_a_row
    Snapshot.maximum(:active_days_in_a_row)
  end

  def record_active_weeks_in_a_row
    Snapshot.maximum(:active_weeks_in_a_row)
  end

  private

  def units_in_range(units, range)
    if range.to_s == range.to_s.pluralize
      "#{units.upcase}_IN_#{range.upcase}".constantize.to_f
    else
      "#{units.upcase}_IN_A_#{range.upcase}".constantize.to_f
    end
  end

  def percent(float)
    sprintf('%.1f', float * 100)
  end
end
