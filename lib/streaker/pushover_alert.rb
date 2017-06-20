class PushoverAlert
  attr_reader :message, :title

  def initialize(title:, message:)
    @title = title
    @message = message
  end

  def call
    HTTP.post(url, params: payload)
  end

  private

  def payload
    {
      token: Streaker.config.pushover_token,
      user: Streaker.config.pushover_user_key,
      message: message,
      title: title,
      sound: 'bugle',
      html: 1
    }
  end

  def url
    @url ||= "https://api.pushover.net/1/messages.json"
  end
end
