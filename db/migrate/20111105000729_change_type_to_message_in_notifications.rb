#The type field needs to be changed to "message" to fix an issue in which
#it is clashing with a build in field.

class ChangeTypeToMessageInNotifications < ActiveRecord::Migration
  def self.up
  	remove_column :notifications, :type
  	add_column :notifications, :message, :string
  end

  def self.down
  	add_column :notifications, :type, :string
  	remove_column :notifications, :message
  end
end
