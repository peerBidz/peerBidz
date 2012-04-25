class Notification < ActiveRecord::Base
	belongs_to :user

	validates_presence_of :item_id, :message

	validates_associated :user
end
