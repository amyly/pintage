class BookmarksController < ApplicationController
  def create
    @user = User.find(current_user.id)
    @user.get_all_pins(@user)
    redirect_to root_url
  end
end
