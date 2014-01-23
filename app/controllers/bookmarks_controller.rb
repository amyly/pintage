class BookmarksController < ApplicationController
  def create_pinboard
    @user = User.find(current_user.id)
    @user.get_all_bookmarks
    redirect_to root_url, notice: "Success! Your bookmarks have been retrieved."
  end

  def delete_pinboard
    @user = User.find(current_user.id)
    @user.delete_all_bookmarks
    redirect_to edit_user_registration_path, notice: "Your Pinboard account was disconnected."
  end
end
