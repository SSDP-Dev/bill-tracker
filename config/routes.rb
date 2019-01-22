Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "pages#index"
  resources :bills
  post '/follow', to: "bills#bill_follow"
  get '/following', to: "bills#following"
  get '/activity', to: "bills#activity"
end
