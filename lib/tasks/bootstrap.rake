namespace :bootstrap do
	#To run this file, use the comand "bundle exec rake bootstrap:all"
	#Note: you may want to run a "rake:db drop" and "bundle exec rake db:migrate"
	#   first to start with a fresh db. This is not necessary however.

	#----------
	#CATEGORIES
	#----------
	# This is used to generate the default category entries for the database.
	#
	# To createbidding a new top level category (ex. "Electronics", add an entry below without a parent ID value)
	# To createbidding a new child category (ex. "Computers", add an entry below with the lookup for
	#   the parent (ex. "Electronics") category).
	# (See below for examples)
	#
	# This task removes all existing categories from the DB and then inserts the new ones
	desc "Add all initial categories"
	task :default_categories => :environment do
		#clear all existing categories
		Category.destroy_all

		#GENERAL
		Category.create(:name => "General")
		Category.create(:name => "Books", :parentID => Category.find_by_name("General").id)
		Category.create(:name => "Music", :parentID => Category.find_by_name("General").id)
		Category.create(:name => "Movies", :parentID => Category.find_by_name("General").id)


		#ELECTRONICS
		Category.create(:name => "Electronics")
		Category.create(:name => "Computers", :parentID => Category.find_by_name("Electronics").id)
		Category.create(:name => "Mobile", :parentID => Category.find_by_name("Electronics").id)
		Category.create(:name => "Home", :parentID => Category.find_by_name("Electronics").id)
		Category.create(:name => "Cameras", :parentID => Category.find_by_name("Electronics").id)

		#FASHION
		Category.create(:name => "Fashion")
		Category.create(:name => "Men", :parentID => Category.find_by_name("Fashion").id)
		Category.create(:name => "Women", :parentID => Category.find_by_name("Fashion").id)
		Category.create(:name => "Kids", :parentID => Category.find_by_name("Fashion").id)

	end

	desc "Create default admin account"
	task :default_admin => :environment do
		AdminUser.create(:email => 'admin@bestbay.com', :password => 'rockingonrails', :password_confirmation => 'rockingonrails')
	end

	desc "Run all tasks"
	task :all => [:default_categories, :default_admin]	
	
end