module Notifications
  class CreateService
    def self.call(user:, title:, message:, notifiable:)
      Notification.create!(
        user: user,
        title: title,
        message: message,
        notifiable: notifiable
      )
    end
  end
end
