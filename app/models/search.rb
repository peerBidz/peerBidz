class Search < ActiveRecord::Base
  def items
    @items ||= find_items
  end

private

def find_items
  Item.find(:all, :conditions => conditions)
end

def keyword_conditions
  ["items.title LIKE ?", "%#{keywords}%"] unless keywords.blank?
end

def minimum_price_conditions
  ["items.bidvalue >= ?", minimum_price] unless minimum_price.blank?
end

def maximum_price_conditions
  ["items.bidvalue <= ?", maximum_price] unless maximum_price.blank?
end

def category_conditions
  ["items.category_id = ?", category_id] unless category_id.blank?
end

def seller_conditions
  #This if statement is requied because otherwise we will get an error.
  #The error is a result of a lookup for the id field on a null object if there
  #  is no such entry for the seller ID. -CD
  if User.find_by_email(seller_email).blank?
    #I am setting the seller ID to an ID that will never be assigned..
    #..therefore no results will be returned since we are restricting our results
    #..to those from that particular seller email.
    #
    #....a better implementation would be to throw an error message to the user
    #....saying that the email was not a valid seller, but we can implement this later. -CD 
    @seller_id = -1
  else
    @seller_id = User.find_by_email(seller_email).id
  end

  ["items.seller_id = ?", @seller_id] unless seller_email.blank?
end

def conditions
  [conditions_clauses.join(' AND '), *conditions_options]
end

def conditions_clauses
  conditions_parts.map { |condition| condition.first }
end

def conditions_options
  conditions_parts.map { |condition| condition[1..-1] }.flatten
end

def conditions_parts
  private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
end

end
