class PostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def show 
    @post = Post.find(params[:id])
  end
  def create
    @post  = current_user.posts.build(params[:post])

    if @post.save
      params[:tags_string][:name].split.each do |i|
        if t = Tag.find_by_name(i)
          @post.describe!(t)
        else
          @post.tags.create!(:name => i)
        end    
      end

      flash[:success] = "Post created!"
      redirect_to current_user
    else
      @feed_items = []
      render 'pages/home'
    end

  end

  def destroy
    @post.destroy
    redirect_back_or current_user
  end
  
  private

    def authorized_user
      @post = Post.find(params[:id])
      redirect_to root_path unless current_user?(@post.user)
    end
    
end