class SnapshotFill
  attr_reader :snapshot_calculation_constructor

  def initialize(snapshot_calculation_constructor: SnapshotCalculation)
    @snapshot_calculation_constructor = snapshot_calculation_constructor
  end

  def call
    date = start_date
    while date && date < Time.now
      snapshot_calculation_constructor.new(at: date).save
      date += 1.day
    end
  rescue Exception => e
    Streaker.logger.fatal("#{self} died with #{e.class}: #{e.message}")
    raise e
  end

  private

  def start_date
    if last_activity_is_more_recent_that_last_snapshot?
      last_activity.started_at
    elsif last_snapshot
      last_snapshot.shot_at + 1.day
    else
      first_activity.try(:started_at)
    end
  end

  def last_activity_is_more_recent_that_last_snapshot?
    return false unless last_activity && last_snapshot
    last_activity.started_at > last_snapshot.shot_at
  end

  def last_snapshot
    Snapshot.order(:shot_at).last
  end

  def last_activity
    Activity.order(:started_at).last
  end

  def first_activity
    Activity.order(:started_at).first
  end
end
