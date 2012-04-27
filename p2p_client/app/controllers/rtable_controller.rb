class RtableController < ActionController::Base
  def index
    @is_present = Searchresults.where("category = :ct", {:ct => cookies[:CURRCATEGORY]})
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end
end
