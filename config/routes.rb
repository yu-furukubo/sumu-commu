Rails.application.routes.draw do

  namespace :admin do
    get 'circular_member/index'
    get 'circular_member/new'
  end
  root to: "public/homes#top"

  namespace :admin do
    resources :communities, except: [:new]  do
      collection do
        get "residence/:id" => "communities#residence_search" ,as: "residence_search"
      end
      resources :community_comments, only: [:destroy]
      resources :community_members, only: [:update, :destroy]
    end
    resources :exchanges, except: [:new] do
      collection do
        get "residence/:id" => "exchanges#residence_search" ,as: "residence_search"
      end
      resources :exchange_comments, only: [:destroy]
    end
    resources :lost_items do
      collection do
        get "residence/:id" => "lost_items#residence_search" ,as: "residence_search"
      end
      resources :lost_item_comments, only: [:destroy]
    end
    resources :genres, only: [:index, :create, :edit, :update, :destroy] do
      collection do
        get "residence/:id" => "genres#residence_search" ,as: "residence_search"
      end
    end
    resources :reservations, except: [:new] do
      collection do
        get "residence/:id" => "reservations#residence_search" ,as: "residence_search"
      end
    end
    resources :facilities do
      collection do
        get "residence/:id" => "facilities#residence_search" ,as: "residence_search"
      end
    end
    resources :equipments do
      collection do
        get "residence/:id" => "equipments#residence_search" ,as: "residence_search"
      end
    end
    resources :events do
      collection do
        get "residence/:id" => "events#residence_search" ,as: "residence_search"
      end
      resources :event_members, only: [:destroy]
    end
    resources :members, except: [:new, :create] do
      collection do
        get "residence/:id" => "members#residence_search" ,as: "residence_search"
      end
    end
    resources :boards do
      collection do
        get "residence/:id" => "boards#residence_search" ,as: "residence_search"
      end
      resources :circular_members, only: [:index, :new, :create, :update, :destroy]
    end
    resources :residences, except: [:index, :show]
    resources :admins, only: [:show, :edit, :update]
  end

  namespace :public do
    resources :plans
    resources :events do
      resources :event_members, only: [:create, :destroy]
    end
    resources :lost_items do
      resources :lost_item_comments, only: [:create, :destroy]
    end
    resources :exchanges do
      resources :exchange_comments, only: [:create, :destroy]
    end
    resources :reservations
    resources :equipments, only: [:index, :show]
    resources :facilities, only: [:index, :show]
    resources :boards do
      member do
        resources :circular_members, only: [:index, :new, :update]
      end
      resource :reads, only: [:create, :destroy]
    end
    resources :communities do
      member do
        patch "join" => "communities#join"
        resources :community_comments, only: [:index, :create, :destroy]
        resources :community_members, only: [:index, :create, :update, :destroy]
      end
    end
    resources :members do
      collection do
        get "information" => "members#show", as: "member"
        get "information/edit" => "members#edit", as: "member_edit"
        patch "information" => "members#update", as: "member_update"
        delete "information" => "members#destroy", as: "member_destroy"
      end
    end
    resources :residences, only: [:index, :show] do
      devise_scope :members do
        get "member/sign_up" => "devise/registrations#new", as: "new_member_registration"
      end
    end
  end

  devise_for :admin, skip: [:passwords], controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }

  devise_for :members, skip: [:passwords, :registrations], controllers: {
    sessions: 'public/sessions'
  }
  devise_scope :members do
    # get "member/sign_up/:id" => "devise/registrations#new", as: "new_member_registration"
    get "member/edit" => "devise/registrations#edit", as: "edit_member_registration"
    patch "member" => "devise/registrations#update", as: "update_member_registration"
    delete "member" => "devise/registrations#destroy", as: "destroy_member_registration"
    post "member" => "devise/registrations#create", as: "member_registration"
  end
end
