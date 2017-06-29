class Snapshot < ActiveRecord::Base
  CHANGE_COMPARISON_METHODS = [:active_days_in_a_row, :active_weeks_in_a_row]

  def unnotified?
    notified_at.nil?
  end

  def changed_from_previous_notified?
    return true unless previous_unnotified
    comparables != previous_unnotified_comparables
  end

  private

  def comparables
    CHANGE_COMPARISON_METHODS.map { |method_name| send(method_name) }
  end

  def previous_unnotified_comparables
    CHANGE_COMPARISON_METHODS.map do
      |method_name| previous_unnotified.send(method_name)
    end
  end

  def previous_unnotified
    @previous_unnotified ||=
      Snapshot.where(['shot_at < ?', shot_at])
              .where.not(notified_at: nil)
              .order(:shot_at)
              .last
  end
end
