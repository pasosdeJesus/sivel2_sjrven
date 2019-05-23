source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" } 

ruby '2.6.2'

# Rails (internacionalización)
gem 'rails', '~> 6.0.0.rc1'

gem 'rails-i18n'

gem 'bootsnap', '>=1.1.0', require: false

# Colores en terminal
gem 'colorize'

# Servidor web
gem 'puma'

gem 'redcarpet'

# Cuadros de selección para búsquedas
gem 'chosen-rails', git: 'https://github.com/vtamara/chosen-rails.git', branch: 'several-fixes'

# Generación de PDF
gem 'prawn'
gem 'prawnto_2',  :require => 'prawnto'
gem 'prawn-table'

# Plantilla ODT
gem 'odf-report'


# Plantilla ODS
#gem 'rspreadsheet', path: '../rspreadsheet'
gem 'rspreadsheet'
gem 'libxml-ruby'

# Postgresql
gem 'pg'

# API JSON facil. Ver: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'sass-rails'

gem 'webpacker'

# Uglifier comprime recursos Javascript
gem 'uglifier'

# CoffeeScript para recuersos .js.coffee y vistas
gem 'coffee-rails'

# jquery como librería JavaScript
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Seguir enlaces más rápido. Ver: https://github.com/rails/turbolinks
gem 'turbolinks'

# Ambiente de CSS
gem 'twitter-bootstrap-rails'
gem 'bootstrap-datepicker-rails'
gem 'font-awesome-rails'

gem 'chartkick'

# Formularios simples 
gem 'simple_form'

# Formularios anidados (algunos con ajax)
gem 'cocoon', git: 'https://github.com/vtamara/cocoon.git', branch: 'new_id_with_ajax'


# Autenticación y roles
gem 'devise'
gem 'devise-i18n'
gem 'cancancan'
gem 'bcrypt'

# Listados en páginas
gem 'will_paginate'

# ICU con CLDR
gem 'twitter_cldr'

# Maneja adjuntos
gem 'paperclip'

# Zonas horarias
gem 'tzinfo'

# Motor SIP
gem 'sip', git: 'https://github.com/pasosdeJesus/sip.git', branch: :rails6
#gem 'sip', path: '../sip'

# Motor de nube y plantillas
gem 'heb412_gen', git: 'https://github.com/pasosdeJesus/heb412_gen.git', branch: :rails6
#gem 'heb412_gen', path: '../heb412_gen'

# Motor de formularios
gem 'mr519_gen', git: 'https://github.com/pasosdeJesus/mr519_gen.git', branch: :rails6
#gem 'mr519_gen', path: '../mr519_gen'


# Motor de SIVeL 2
gem 'sivel2_gen', git: 'https://github.com/pasosdeJesus/sivel2_gen.git', branch: :rails6
#gem 'sivel2_gen', path: '../sivel2_gen'

# Motor de SIVeL 2 - SJR
gem 'sivel2_sjr', git: 'https://github.com/pasosdeJesus/sivel2_sjr.git', branch: :rails6
#gem 'sivel2_sjr', path: '../sivel2_sjr'

# Motor Cor1440_gen
gem 'cor1440_gen', git: 'https://github.com/pasosdeJesus/cor1440_gen.git', branch: :rails6
#gem 'cor1440_gen', path: '../cor1440_gen'

# Motor Sal7711_gen
gem 'sal7711_gen', git: 'https://github.com/pasosdeJesus/sal7711_gen.git', branch: :rails6
#gem 'sal7711_gen', path: '../sal7711_gen'

# Motor Sal7711_web
gem 'sal7711_web', git: 'https://github.com/pasosdeJesus/sal7711_web.git', branch: :rails6
#gem 'sal7711_web', path: '../sal7711_web'



# Los siguientes son para desarrollo o para pruebas con generadores
group :development do
  # Consola irb en páginas con excepciones o usando <%= console %> en vistasA
  gem 'web-console'

end

# Los siguientes son para desarrollo o para pruebas con generadores
group :development, :test do
  # Depurar
  #gem 'byebug'
  gem 'minitest'
end
 
# Los siguientes son para pruebas y no tiene generadores requeridos en desarrollo
group :test do
  gem 'spring'
  gem 'simplecov'
  gem 'capybara'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'

  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :production do
  # Para despliegue
  gem 'unicorn'

  # Requerido por heroku para usar stdout como bitacora
  gem 'rails_12factor'
end
