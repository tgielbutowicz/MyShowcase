class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end
  
  def create
    @post  = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
end