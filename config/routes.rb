Rails.application.routes.draw do
   # global options responder -> makes sure OPTION request for CORS endpoints work
   match '*path', via: [:options], to: lambda {|_| [204, { 'Content-Type' => 'text/plain' }]}
   
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "pages#index"
  resources :bills
  post '/follow', to: "bills#bill_follow"
  get '/following', to: "bills#following"
  get '/activity', to: "bills#activity"
  get '/collections', to: "collections#index"
  get '/collections/new', to: "collections#new"
  get '/collections/show/:id', to: "collections#show"
  get '/collections/all', to: "collections#all"
  get '/billapi', to: "bills#api"

  get '/api', to: "api#index"
  get '/api/collection/:id', to: "api#collection"
end
