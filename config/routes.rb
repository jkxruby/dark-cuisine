Rails.application.routes.draw do

  mount ChinaCity::Engine => '/china_city'

  root 'welcome#index'
  get 'party/index'
  get 'question/index'
  get 'random/index'
  get 'thanks/index'




  resources :jobs do
    resources :resumes
  end

  resources :comments

  devise_for :users, :controllers => { :registrations => "users/registrations", :sessions => "users/sessions" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do

    resources :jobs do
      member do
        post :publish
        post :hide
      end
    end
    resources :resumes
    resources :categories

    resources :products do
      member do
        patch :move_up
        patch :move_down
      end
    end
    resources :orders do
      member do
        post :cancel
        post :ship
        post :shipped
        post :return
      end
    end
  end

  resources :products do
    resources :comments

    collection do
      get :search
      post :lucky_cart3
      post :lucky_cart4
      post :lucky_cart5
      post :lucky_cart6
      post :lucky_cart7

    end

    member do
      post :add_to_cart
    end
  end

  resources :carts do
    collection do
      delete :clean
      post :checkout
    end
  end

  resources :cart_items

  resources :orders do
    member do
      post :pay_with_alipay
      post :pay_with_wechat
      post :apply_to_cancel
    end
  end

  namespace :account do
    resources :orders
  end


  namespace :dadmin do
    resources :dcategories
    resources :dproducts
    resources :dorders do
      member do
        post :cancel
        post :ship
        post :shipped
        post :return
      end
    end
  end

  resources :dproducts do
      member do
        post :add_to_dcart
      end
    end


  resources :dcarts do
    collection do
      delete :clean
      post :dcheckout
    end
  end

  resources :dcart_items

  resources :dorders do
    member do
      post :pay_with_alipay
      post :pay_with_wechat
      post :apply_to_cancel
    end
  end

  namespace :account do
   resources :dorders
  end

end
