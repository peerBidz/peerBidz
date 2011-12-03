class AddNotificationTypeToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :notification_type, :string
  end

  def self.down
    remove_column :notifications, :notification_type
  end
end
