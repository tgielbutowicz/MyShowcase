class PagesController < ApplicationController
  def home
    @title = "Gallery"
    if signed_in?
      @tags = Tag.all
      @feed_items = Post.all.paginate(:page => params[:page])
    end
  end
  
  def channel
    @title = "Your channel"
    if signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end

end
