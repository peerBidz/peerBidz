module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "PeerBidz"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

def layout_for_my_categories

end

end

