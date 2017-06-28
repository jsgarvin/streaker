class PushoverAlert
  attr_reader :message, :title, :rest_client

  def initialize(title:, message:, rest_client: HTTP)
    @title = title
    @message = message
    @rest_client = rest_client
  end

  def call
    rest_client.post(url, params: payload)
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
    @url ||= 'https://api.pushover.net/1/messages.json'
  end
end
