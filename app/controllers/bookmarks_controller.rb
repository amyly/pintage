class BookmarksController < ApplicationController
  def add_pinboard
    @user = User.find(current_user.id)
    @user.get_all_pinboard
    redirect_to root_url, notice: "Success! Your Pinboard bookmarks have been retrieved."
  end

  def delete_pinboard
    @user = User.find(current_user.id)
    @user.delete_all_pinboard
    redirect_to edit_user_registration_path, notice: "Your Pinboard account has been disconnected."
  end

  def delete_pocket
    @user = User.find(current_user.id)
    @user.delete_all_pocket
    redirect_to edit_user_registration_path, notice: "Your Pocket account has been disconnected."
  end

  def send_single_bookmark
    @user = User.find(current_user.id)
    @user.send_single_random_bookmarks
    redirect_to root_path, notice: "Check your inbox!"
  end
end
