class NotificationsController < ActionController::Base
  def index
    @notifications = Notification.where( "user_id = ? and delivered = ?", params[:user_id], false )
    @notifications.each do |n|
      Notification.update(n.id, :delivered=>true)
    end
  end
end
