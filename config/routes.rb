Carterapp::Application.routes.draw do
  match "/accounts/:id/update_plan", :controller => "accounts", :action => "update_plan"
  devise_for :users, :path_prefix => 'sessions'
  resources :users, :except => [:index, :show]
  resources :requests
  resources :accounts, :except => :index
  match "/accounts", :controller => "accounts", :action => "show"
  match "/dashboards", :controller => "dashboards", :action => "show"

  devise_scope :user do
        get "/login" => "devise/sessions#new"
        delete "/logout" => "devise/sessions#destroy"
  end
  
  root :to => "dashboards#show"

end
