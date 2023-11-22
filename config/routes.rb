Rails.application.routes.draw do

  root to: "public/homes#top"

  namespace :admin do
    get "residence/confirm/:id" => "residences#confirm", as: "residence_confirm"
    resources :residences, except: [:index, :show] do
      resources :communities, except: [:new]  do
        resources :community_comments, only: [:update]
        resources :community_members, only: [:update, :destroy]
      end
      resources :exchanges, except: [:new] do
        resources :exchange_comments, only: [:update]
      end
      resources :lost_items do
        resources :lost_item_comments, only: [:update]
      end
      resources :genres, only: [:index, :create, :edit, :update]
      resources :reservations
      resources :facilities
      resources :equipments
      resources :events do
        resources :event_members, only: [:index, :create]
        patch "event_members_invite_all" => "event_members#invite_all", as: "event_members_invite_all"
        delete "event_members/quit_invite/:id" => "event_members#quit_invite", as: "event_member_quit_invite"
      end
      resources :members, except: [:new, :create]
      resources :boards do
        resource :circular_members, only: [:create, :destroy]
        get "circuler_members" => "circular_members#index", as: "circular_members_index"
        patch "circular_members_add_all" => "circular_members#add_all", as: "circular_members_add_all"
      end
      resources :admins, only: [:show, :edit, :update]
      get "search" => "searches#search", as: "search"
      get "search/result" => "searches#search_result", as: "search_result"
    end
  end

  scope module: :public do
    resources :plans
    resources :events do
      resources :event_members, only: [:index, :create, :update, :destroy]
      post "event_members_invite_all" => "event_members#invite_all", as: "event_members_invite_all"
      post "event_members/participate" => "event_members#participate", as: "event_members_participate"
      delete "event_members/decline/:id" => "event_members#decline", as: "event_member_decline"
      delete "event_members/quit_invite/:id" => "event_members#quit_invite", as: "event_member_quit_invite"
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
      resource :circular_members, only: [:create, :destroy]
      get "circuler_members" => "circular_members#index", as: "circular_members_index"
      patch "circular_members_add_all" => "circular_members#add_all", as: "circular_members_add_all"
      resource :reads, only: [:create, :destroy]
    end
    resources :communities do
      resources :community_comments, only: [:create, :update, :destroy]
      resources :community_members, only: [:index, :create, :update, :destroy]
      delete "community_members_quit" => "community_members#quit", as: "community_member_quit"
    end
    get "members/information" => "members#index", as: "members_information"
    get "member/information" => "members#show", as: "member_information"
    get "member/information/edit" => "members#edit", as: "edit_member_information"
    patch "member/information" => "members#update", as: "update_member_information"
    delete "member/information" => "members#destroy", as: "destroy_member_information"
    resources :residences, only: [:index, :show]

    get "search" => "searches#search", as: "search"
    get "search/result" => "searches#search_result", as: "search_result"
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
