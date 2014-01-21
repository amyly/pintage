class WelcomeController < ApplicationController
  def index
    @bookmarks = User.find(current_user.id).bookmarks.where(sent_back: true).order(sent_back_date: :desc)
  end
end
