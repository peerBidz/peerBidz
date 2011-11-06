class NotificationsController < ActionController::Base
	def index
		@notifications = Notification.where( "user_id = ? and created_at > ?", params[:user_id], Time.at(params[:after].to_i + 1) )
	end

end
