Guru::Application.routes.draw do

  concern :csv_exportable do
    get :export, on: :collection, :constraints => { format: :csv }
  end

  devise_for :users, skip: [:registrations], path: '', path_names: { sign_in: 'login', sign_out: 'logout' }

  authenticated :user do
    root to: 'dashboard#index'
  end

  namespace :dashboard do
    get :index
    get :visits, constraints: { format: :json }
    get :sources, constraints: { format: :json }
  end

  namespace :members, as: 'member' do
    resource :import, only: [:new, :create], as: 'import'
  end

  resources :members do
    concerns :csv_exportable

    delete :destroy_multiple, on: :collection
    get :active, on: :collection
    get :inactive, on: :collection

    resources :notes, except: [:show, :index], module: 'members'
    resource :account, except: [:show, :destroy]

    resources :payments, except: [:show, :edit, :update] do
      concerns :csv_exportable
    end

    resources :visits, except: :show do
      concerns :csv_exportable
    end
  end

  resources :classes, except: :show, concerns: :csv_exportable
  resources :levels, except: :show, concerns: :csv_exportable
  resources :sources, except: :show, concerns: :csv_exportable

  namespace :settings do
    resource :studio, only: [:edit, :update]
    resource :members, only: [:edit, :update], as: 'member'
    resources :users, except: [:show]
  end

  namespace :reports do
    namespace :members do
      namespace :birthdays do
        get '/(:month)/export', to: :export, as: :export, :constraints => { format: :csv }
        get '/(:month)', to: :index
      end
      namespace :recent do
        get :export
        get '/', to: :index
      end
    end

    namespace :attendance do
      get '/(:month)/(:year)/export', to: :export, as: :export, :constraints => { format: :csv }
      get '/(:month)/(:year)', to: :index
    end

    namespace :accounts do
      get :export, constraints: { format: :csv }
      get '/(:type)', to: :index
    end

    namespace :payments do
      get '/(:month)/(:year)/export', to: :export, as: :export, :constraints => { format: :csv }
      get '/(:month)/(:year)', to: :index
    end
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
