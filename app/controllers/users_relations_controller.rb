class UsersRelationsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:users_relation][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user } #when js is disabled
      format.js #else
    end
  end

  def destroy
    @user = UsersRelation.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end