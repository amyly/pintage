Pintage::Application.routes.draw do

  root 'welcome#index'
  devise_for :users, :controllers => { :registrations => "registrations" }
  get 'pinboard/add' => 'bookmarks#add_pinboard'
  get 'pinboard/unlink' => 'bookmarks#delete_pinboard'
  get 'pocket/unlink' => 'bookmarks#delete_pocket'
  get 'auth/pocket/callback' => 'accounts#add_pocket'

end
