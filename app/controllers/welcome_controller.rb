class WelcomeController < ApplicationController
  def index
    if current_user
      @sent_bookmarks = User.find(current_user.id).bookmarks.where(sent_back: true).order(sent_back_date: :desc)
    end
  end

  def about
  end
end
