Pintage::Application.routes.draw do

  root 'welcome#index'
  devise_for :users, :controllers => { :registrations => "registrations" }
  devise_scope :user do
    post "users/sign_up", :to => "devise/registrations#new"
  end
  get 'pinboard/add' => 'bookmarks#add_pinboard'
  get 'pinboard/unlink' => 'bookmarks#delete_pinboard'
  get 'pocket/unlink' => 'bookmarks#delete_pocket'
  get 'bookmarks/send' => 'bookmarks#send_single_bookmark'
  get 'auth/pocket/callback' => 'accounts#add_pocket'
  get 'about' => 'welcome#about'
end
