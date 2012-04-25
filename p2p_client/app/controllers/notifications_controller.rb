class NotificationsController < ActionController::Base
  def index
    @notifications = Notification.where( "delivered = ?", false )
    @notifications.each do |n|
      Notification.update(n.id, :delivered=>true)
    end
  end
end
