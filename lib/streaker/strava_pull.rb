require 'strava/api/v3'
class StravaPull
  attr_reader :client_constructor

  def initialize(client_constructor: Strava::Api::V3::Client)
    @client_constructor = client_constructor
  end

  def call
    strava_activities.each do |strava_activity|
      Streaker.logger.info("Creating Activity: #{strava_activity}")
      Activity.create_with(
        started_at: DateTime.parse(strava_activity['start_date']),
        strava_type: strava_activity['type'],
        distance_in_meters: strava_activity['distance'].to_f,
        moving_time_in_seconds: strava_activity['moving_time'].to_i
      ).find_or_create_by(strava_id: strava_activity['id'])
    end
  rescue Exception => e
    Streaker.logger.fatal("#{self} died with #{e}: #{e.message}")
    raise e
  end

  private

  def strava_activities
    client.list_athlete_activities(after: from_date.to_time.to_i,
                                   per_page: 200)
  end

  def client
    @client ||=
      client_constructor.new(access_token: Streaker.config.strava_token)
  end

  def from_date
    last_activity.try(:started_at) || Date.new(1970, 1, 1)
  end

  def last_activity
    Activity.order(:started_at).last
  end
end
