Rails.application.routes.draw do

  # root
  root "nothing#index"
  resources :nothing, only: [:index]
  get "/nothing_just_test", to: "nothing_just_test#index"
  get "/hello_world", to: "posts#hello"
  get "/bmi", to: "bmi#index"
  post "/bmi/result", to: "bmi#result"

  # users & dvise
  devise_for :models
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_scope :users do
    resources :posts
  end
  post "/posts/output",to: "posts#output"
  

  resources :users, except: [:new] do
    member do
      get :mail, to: "users#send_mail"
    end
  end

  # mailpages
  resources :mailpages do
    delete 'destroy_multiple', :on => :member
  end

  # coffees
  resources :coffees, except: [:show] do
    collection do
      get :action
    end
    member do
      get :import
    end
  end

  # resumes
  resources :resumes, only: [:new, :create, :destroy]
  get 'resumes/index'
  get 'resumes/new'
  get 'resumes/create'
  get 'resumes/destroy'
  
  # candidates
  resources :candidates do
    member do
      post :vote
    end
  end

  # products & cart
  resources :products
  resource :cart, only:[:show, :destroy] do
    collection do
      post :add, path:'add/:id'
      post :clear, path:'clear/all'
    end
  end
  post "/products/import",to: "products#import"
  
end
