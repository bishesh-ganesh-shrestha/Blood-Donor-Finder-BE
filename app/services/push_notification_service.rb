# app/services/push_notification_service.rb

require "net/http"
require "json"

class PushNotificationService
  EXPO_URL = URI("https://exp.host/--/api/v2/push/send")

  def self.call(user:, title:, body:, data: {})
    return if user.expo_push_token.blank?

    http = Net::HTTP.new(EXPO_URL.host, EXPO_URL.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(EXPO_URL)
    request["Content-Type"] = "application/json"

    request.body = {
      to: user.expo_push_token,
      title: title,
      body: body,
      sound: "default",
      data: data
    }.to_json

    response = http.request(request)

    Rails.logger.info(response.body)
  rescue => e
    Rails.logger.error("Push notification failed: #{e.message}")
  end
end
