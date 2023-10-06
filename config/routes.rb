Rails.application.routes.draw do

  root to: "public/homes#top"

  namespace :admin do
    resources :communities do
      resources :community_comments, only: [:destroy]
    end
    resources :exchanges, except: [:new] do
      resources :exchange_comments, only: [:destroy]
    end
    resources :lost_items do
      resources :lost_item_comments, only: [:destroy]
    end
    resources :genres, only: [:index, :create, :edit, :update]
    resources :reservations, exept: [:new]
    resources :facilities
    resources :equipments
    resources :events
    resources :members, exept: [:new, :create] do
      collection do
        get "residence/:id" => "members#residence_search" ,as: "residence_search"
      end
    end
    resources :boards do
      collection do
        get "residence/:id" => "boards#residence_search" ,as: "residence_search"
      end
    end
    resources :residences, only: [:new, :create]
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
      resources :circular_members, only: [:index, :update], on: :member
      resource :reads, only: [:create, :destroy]
    end
    resources :communities do
      member do
        patch "join" => "communities#join"
        resources :community_comments, only: [:index, :create, :destroy]
        resources :community_members, only: [:index, :create, :update, :destroy]
      end
    end
    resource :members do
      collection do
        get "information" => "members#show", as: "member"
        get "information/edit" => "members#edit", as: "member_edit"
        patch "information" => "members#update", as: "member_update"
        delete "information" => "members#destroy", as: "member_destroy"
      end
    end
    resources :residences, only: [:index, :show]
  end

  devise_for :admin, skip: [:passwords], controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }

  devise_for :members, skip: [:passwords, :registrations], controllers: {
    sessions: 'public/sessions'
  }
  devise_scope :members do
    get "member/:residence_id/sign_up" => "devise/registrations#new", as: "new_member_registration"
    get "member/edit" => "devise/registrations#edit", as: "edit_member_registration"
    patch "member" => "devise/registrations#update", as: "update_member_registration"
    delete "member" => "devise/registrations#destroy", as: "destroy_member_registration"
    post "member" => "devise/registrations#create", as: "member_registration"
  end
end
