module Notifications
  class CreateService
    def self.call(user:, title:, message:, notifiable:)
      notification = Notification.create!(
        user: user,
        title: title,
        message: message,
        notifiable: notifiable
      )

      PushNotificationService.call(
        user: user,
        title: title,
        body: message,
        data: {
          notification_id: notification.id
        }
      )

      notification
    end
  end
end
