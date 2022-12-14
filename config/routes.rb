Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    get 'search' => 'homes#search', as: 'search'
    resources :users, only: [:index, :show, :edit, :update] do
      resources :reviews, only: [:index, :show, :edit, :update, :destroy]
    end
    resources :works, only: [:index, :show, :edit, :update, :destroy]
    resources :skills, only: [:index, :show, :edit, :update, :destroy]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :orders, only: [:index, :show, :update] do
      resources :order_details, only: [:update]
    end
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
    get 'users/:id/favorites' => 'users#favorites', as: 'favorites'
    get 'users/information/edit' => 'users#edit', as: 'edit_information'
    patch 'users/information' => 'users#update', as: 'update_information'
    get 'users/information/unsubscribe' => 'users#unsubscribe', as: 'confirm_unsubscribe'
    put 'users/information' => 'users#update'
    patch 'users/withdraw' => 'users#withdraw', as: 'withdraw_user'
    delete 'cart_items/destroy_all' => 'cart_items#destroy_all', as: 'destroy_all_cart_items'
    post 'orders/confirm' => 'orders#confirm'
    get 'orders/confirm' => 'orders#error'
    get 'orders/thanks' => 'orders#thanks', as: 'thanks'
# users/:id と users/unsubscribeが存在した場合:idはなんでも入るのでunsubscribeが入ってしまう。
# profileページが表示され、退会ページが表示されない。なのでinformationを挟むことにした。
    resources :skills, only: [:new, :create, :index, :show, :edit, :update] do
      resources :cart_items, only: [:create, :update, :destroy]
    end
    resources :cart_items, only: [:index]
    resources :works do
      resource :favorites, only: [:create, :destroy]
      resources :reviews, only: [:index, :create, :edit, :update, :destroy]
    end

    resources :users, except: [:new,:index, :show, :edit, :create, :update, :destroy] do
      member do
        get :follows, :followers
      end
      resource :relationships, only: [:create, :destroy]
    end

    resources :orders, only: [:new, :index, :create, :show, :update, :destroy] do
      resources :order_details, only: [:update]
    end

    resources :messages, only: [:create]
    resources :rooms, only: [:create, :index, :show]
    resources :entries, only: [:index]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
