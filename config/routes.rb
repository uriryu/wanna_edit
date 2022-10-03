Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    get 'search' => 'homes#search', as: 'search'
    resources :users, only: [:index, :show, :edit, :update]
    resources :reviews, only: [:index, :show, :edit, :update, :destroy]
    resources :works, only: [:index, :show, :edit, :update, :destroy]
  end

  devise_for :users, controllers: {
    registrations: "public/registrations",
    passwords: 'public/passwords', #ゲストユーザーの追加でパスワードを設定させない為追記  skip: [:passwords],を削除中.
    sessions: 'public/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    root to: "homes#top"
    get 'search' => 'homes#search', as: 'search'
    get 'users/mypage' => 'users#show', as: 'mypage'
    get 'users/:id' => 'users#profile', as: 'profile'
    get 'users/information/edit' => 'users#edit', as: 'edit_information'
    patch 'users/information' => 'users#update', as: 'update_information'
    get 'users/unsubscribe' => 'users#unsubscribe', as: 'confirm_unsubscribe'
    put 'users/information' => 'users#update'
    patch 'users/withdraw' => 'users#withdraw', as: 'withdraw_user'
    resources :works

    resources :users, except: [:new,:index, :show, :edit, :create, :update, :destroy] do
      member do
        get :follows, :followers
      end
      resource :relationships, only: [:create, :destroy]
    end

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
