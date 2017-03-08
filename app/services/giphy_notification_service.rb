class GiphyNotificationService
  attr_accessor :client

  def initialize(app_token: nil)
    Slack.configure do |config|
      config.token = app_token
      config.token ||= Ibotta::Application.config.slack[:token]
    end
    @client = Slack::RealTime::Client.new

    client.on :message do |data|

      case data.text
      when /^jify .*/ then
        text = data.text.match(/^jify (.*)/)[1]
        url = Giphy.random(text).url.to_s
        client.message(channel: data.channel, text: "#{url}") unless data.channel == "#alerts"
      end
    end
  end

  def send_notification(message, channel = "#alerts" )
    @client.chat_postMessage(channel: channel, text: message, as_user: true)
  end

end
