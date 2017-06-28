describe PushoverAlert do
  let(:message) { 'This is a message' }
  let(:title) { 'This is a title' }
  let(:url) { 'https://api.pushover.net/1/messages.json' }
  let(:client) { double('HTTP') }
  let(:alert) do
    PushoverAlert.new(title: title,
                      message: message,
                      rest_client: client)
  end

  let(:payload) do
    {
      token: Streaker.config.pushover_token,
      user: Streaker.config.pushover_user_key,
      message: message,
      title: title,
      sound: 'bugle',
      html: 1
    }
  end


  describe '#call' do
    it 'posts to pushover' do
      expect(client).to receive(:post).with(url, params: payload)
      alert.call
    end
  end
end
