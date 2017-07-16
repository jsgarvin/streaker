class AlertCheck
  attr_reader :alert_constructor, :notification_constructor

  def initialize(alert_constructor: PushoverAlert,
                 notification_constructor: Notification)
    @alert_constructor = alert_constructor
    @notification_constructor = notification_constructor
  end

  def call
    if send_alert?
      Streaker.logger.info("Sending Alert: #{payload_data.to_s}")
      alert_constructor.new(title: 'Streaker Notification',
                            message: message)
                       .call
      notification_constructor.create(payload_digest: payload_digest)
    end
  rescue Exception => e
    Streaker.logger.fatal("#{self} died with #{e}: #{e.message}")
    raise e
  end

  private

  def send_alert?
    last_snapshot &&
      last_snapshot_newer_than_last_notification? &&
      paylist_digest_has_changed_since_last_notification?
  end

  def last_snapshot_newer_than_last_notification?
    last_notification.nil? ||
      last_notification.created_at < last_snapshot.shot_at
  end

  def paylist_digest_has_changed_since_last_notification?
    last_notification.nil? ||
      payload_digest != last_notification.payload_digest
  end

  def message
    ERB.new(template).result(payload_data.get_binding)
  end

  def payload_digest
    @payload_digest ||= Digest::SHA512.hexdigest(payload_data.to_s)
  end

  def payload_data
    @payload_data ||= BindableStruct.new(
      active_days_in_a_row: last_snapshot.active_days_in_a_row_with_fallback,
      active_weeks_in_a_row: last_snapshot.active_weeks_in_a_row_with_fallback,
      record_active_days_in_a_row: record_active_days_in_a_row,
      record_active_weeks_in_a_row: record_active_weeks_in_a_row
    )
  end

  def last_snapshot
    @last_snapshot ||= Snapshot.where(['shot_at > ?', 48.hours.ago])
            .order(:shot_at)
            .last
  end

  def last_notification
    @last_notification ||= Notification.order(:created_at).last
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

  class BindableStruct < OpenStruct
    def get_binding
      binding
    end
  end
end
