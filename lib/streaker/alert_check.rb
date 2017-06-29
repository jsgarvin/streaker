class AlertCheck
  attr_reader :alert_constructor

  def initialize(alert_constructor: PushoverAlert)
    @alert_constructor = alert_constructor
  end

  def call
    if send_alert?
      alert_constructor.new(title: 'Streaker Notification',
                            message: message)
                       .call
      snapshot.update(notified_at: Time.now)
    end
  end

  private

  def send_alert?
    snapshot &&
      snapshot.unnotified? &&
      snapshot.changed_from_previous_notified?
  end

  def snapshot
    Snapshot.where(['shot_at > ?', 48.hours.ago])
            .order(:shot_at)
            .last
  end

  def message
    ERB.new(template).result(binding)
  end

  def template
    File.open("#{Streaker.root}/templates/pushover_message.html.erb").read
  end

  def record_active_days_in_a_row
    Snapshot.maximum(:active_days_in_a_row)
  end

  def record_active_weeks_in_a_row
    Snapshot.maximum(:active_weeks_in_a_row)
  end
end
