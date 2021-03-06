Rails.application.routes.draw do
  mount TuftsModelsNg::Engine => "/", as: "tufts_models_engine"
  mount UserImpersonate::Engine => "/impersonate", as: "impersonate_engine"
  mount Blacklight::Engine => '/'

    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end
  resources :records, only: [:new]

  unauthenticated do
    root to: 'contribute#redirect'
  end

  resources :contribute, as: 'contributions', :controller => :contribute, :only => [:index, :new, :create] do
    collection do
      get 'license'
    end
  end

  devise_for :users
  mount CurationConcerns::Engine, at: '/'
  # resources :welcome, only: 'index'
  # root 'catalog#index'
  curation_concerns_collections
  curation_concerns_basic_routes
  curation_concerns_embargo_management
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

end
