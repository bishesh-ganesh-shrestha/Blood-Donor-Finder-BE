# app/controllers/notifications_controller.rb

class NotificationsController < ApplicationController
  def index
    pagy, notifications = pagy(
      current_user.notifications.order(created_at: :desc),
      items: 10
    )

    render json: {
      notifications: notifications,
      meta: {
        page: pagy.page,
        pages: pagy.pages,
        count: pagy.count
      }
    }
  end

  def mark_as_read
    notification =
      current_user.notifications.find(params[:id])

    notification.update!(
      read_at: Time.current
    )

    render json: {
      message: "Notification marked as read"
    }
  end

  def read_all
    current_user.notifications
                .unread
                .update_all(
                  read_at: Time.current
                )

    render json: {
      message: "All notifications marked as read"
    }
  end
end
