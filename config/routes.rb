Rails.application.routes.draw do

  devise_scope :usuario do
    get 'sign_out' => 'devise/sessions#destroy'
  end
  devise_for :usuarios, :skip => [:registrations], module: :devise
    as :usuario do
          get 'usuarios/edit' => 'devise/registrations#edit', 
            :as => 'editar_registro_usuario'    
          put 'usuarios/:id' => 'devise/registrations#update', 
            :as => 'registro_usuario'            
  end
  resources :usuarios, path_names: { new: 'nuevo', edit: 'edita' } 

  patch "/actos/agregar" => 'sivel2_sjr/actos#agregar'
  get "/actos/eliminar" => 'sivel2_sjr/actos#eliminar'
  
  get "/personas" => 'sivel2_sjr/personas#index'
  get "/personas/remplazar" => 'sivel2_sjr/personas#remplazar'

  #root 'sivel2_gen/hogar#index'
  mount Sip::Engine => "/", as: 'sip'
  mount Sivel2Sjr::Engine => "/", as: 'sivel2_sjr'
  mount Sivel2Gen::Engine => "/", as: 'sivel2_gen'
  mount Cor1440Gen::Engine => "/", as: 'cor1440_gen'


  namespace :admin do
    Ability.tablasbasicas.each do |t|
      if (t[0] == "") 
        c = t[1].pluralize
        resources c.to_sym, 
          path_names: { new: 'nueva', edit: 'edita' }
      end
    end
  end
end
