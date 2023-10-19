Rails.application.routes.draw do

  root to: "public/homes#top"

  namespace :admin do
    resources :communities, except: [:new]  do
      collection do
        get "residence/:id" => "communities#residence_search" ,as: "residence_search"
      end
      resources :community_comments, only: [:update]
      resources :community_members, only: [:update, :destroy]
    end
    resources :exchanges, except: [:new] do
      collection do
        get "residence/:id" => "exchanges#residence_search" ,as: "residence_search"
      end
      resources :exchange_comments, only: [:update]
    end
    resources :lost_items do
      collection do
        get "residence/:id" => "lost_items#residence_search" ,as: "residence_search"
      end
      resources :lost_item_comments, only: [:update]
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
      resources :circular_members, only: [:index, :create, :destroy]
    end
    resources :residences, except: [:index, :show]
    resources :admins, only: [:show, :edit, :update]
  end

  namespace :public do
    resources :plans
    resources :events do
      resources :event_members, only: [:index, :create, :update, :destroy]
      post "event_members/participate" => "event_members#participate", as: "event_members_participate"
      delete "event_members/observe/:id" => "event_members#observe", as: "event_member_observe"
    end
    resources :lost_items do
      resources :lost_item_comments, only: [:create, :update, :destroy]
    end
    resources :exchanges do
      resources :exchange_comments, only: [:create, :update, :destroy]
    end
    resources :reservations
    get "reservation/select" => "reservations#select", as: "reservations_select"

    resources :equipments, only: [:index, :show]
    resources :facilities, only: [:index, :show]
    resources :boards do
      resources :circular_members, only: [:index, :create, :destroy]
      resource :reads, only: [:create, :destroy]
    end
    resources :communities do
      resources :community_comments, only: [:create, :update, :destroy]
      resources :community_members, only: [:index, :create, :update, :destroy]
    end
    get "member/information" => "members#show", as: "member_information"
    get "member/information/edit" => "members#edit", as: "edit_member_information"
    patch "member/information" => "members#update", as: "update_member_information"
    delete "member/information" => "members#destroy", as: "destroy_member_information"
    resources :residences, only: [:index, :show]
  end

  devise_for :admin, skip: [:passwords], controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }

  devise_for :members, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_scope :member do
    post "members/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

end
