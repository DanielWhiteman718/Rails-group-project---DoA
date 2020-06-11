Rails.application.routes.draw do

  mount EpiCas::Engine, at: "/"
  devise_for :users
  match "/403", to: "errors#error_403", via: :all
  match "/404", to: "errors#error_404", via: :all
  match "/422", to: "errors#error_422", via: :all
  match "/500", to: "errors#error_500", via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  # Sets main page to edit requests
  root to: "edit_requests#index"

  resources :edit_requests do
    get 'respond', to: "edit_requests#respond", on: :collection
    #post 'respond', on: :collection
    #post 'respond_to_request', on: :collection
    post '/bulk', to: 'edit_requests#bulk', on: :collection
    post '/single', to: 'edit_requests#single', on: :member
    post '/reject', to: 'edit_requests#reject', on: :member
    post '/create', to: "edit_requests#create", on: :member
  end
  # Please keep 'resources :users' below the line that mounts the epicas
  # engine to avoid an error
  resources :users do
    get '/audit', to: 'users#audit', on: :member
  end
  resources :rooms do
    get '/audit', to: 'rooms#audit', on: :member
  end
  resources :programmes do
    get '/audit', to: 'programmes#audit', on: :member
  end
  resources :uni_modules do
    get '/audit', to: 'uni_modules#audit', on: :member
  end
  resources :themes do
    get '/audit', to: 'themes#audit', on: :member
  end
  resources :objectives do
    get '/audit', to: 'objectives#audit', on: :member
  end
  resources :activity_objectives do
    get '/audit', to: 'activity_objectives#audit', on: :member
  end
  resources :settings
  resources :dropdowns do
    get '/audit', to: 'dropdowns#audit', on: :member
  end
  resources :activities do
    # General CSV output
    # GET is for all activities (unfiltered)
    match '/output' => 'activities#all_output', via: :get, on: :collection
    # POST is for filtered activity list (as activity ids need to be passed in)
    match '/output' => 'activities#some_output', via: :post, on: :collection
    # Lab book CSV output
    match '/lab_book' => 'activities#lab_book_all', via: :get, on: :collection
    match 'lab_book' => 'activities#lab_book_some', via: :post, on: :collection
    get '/change_module', to: 'activities#change_module', on: :collection
    get '/reset', to: 'activities#reset', on: :collection
    get '/crerequest', to: 'activities#crerequest', on: :member
    get '/filter', to: 'activities#filter', on: :collection
    get '/audit', to: 'activities#audit', on: :member
    get :my_activities, on: :collection
    get '/send_bulk', to: 'activities#send_bulk', on: :collection
    post '/bulk_request', to: 'activities#bulk_request', on: :collection
  end
  resources :analytics do
    get '/view', to: 'analytics#view', on: :collection
    get '/view2', to: 'analytics#view2', on: :collection
    get '/view3', to: 'analytics#view3', on: :collection
    get '/view4', to: 'analytics#view4', on: :collection
    get '/view5', to: 'analytics#view5', on: :collection
    get '/view6', to: 'analytics#view6', on: :collection
    get '/view7', to: 'analytics#view7', on: :collection
    get '/view8', to: 'analytics#view8', on: :collection
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
