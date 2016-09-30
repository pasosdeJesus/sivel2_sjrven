source 'https://rubygems.org'

# Rails (internacionalización)
gem "rails", '~> 5.0.0'
gem "rails-i18n"

# Postgresql
gem "pg"

gem 'puma'

# PDF
gem "prawn"
gem "prawnto_2",  :require => "prawnto"
gem "prawn-table"

# Maneja variables de ambiente (como claves y secretos) en .env
gem "foreman"

# API JSON facil. Ver: https://github.com/rails/jbuilder
gem "jbuilder"

# SCSS para hojas de estilo
gem "sass"
gem "sass-rails"

# Colores en terminal
gem "colorize"

# Uglifier comprime recursos Javascript
gem "uglifier"

# CoffeeScript para recuersos .js.coffee y vistas
gem "coffee-rails"

# jquery como librería JavaScript
gem "jquery-rails"
gem "jquery-ui-rails"

# Cuadros de selección para búsquedas 
gem 'chosen-rails' 

# Seguir enlaces más rápido. Ver: https://github.com/rails/turbolinks
gem "turbolinks", '2.5.3'

# Ambiente de CSS
gem "twitter-bootstrap-rails"
gem "bootstrap-datepicker-rails"
gem "bootstrap-sass"
gem "font-awesome-rails" 

gem "chartkick"

# Formularios simples 
gem "simple_form"

# Formularios anidados (algunos con ajax)
gem "cocoon", git: "https://github.com/vtamara/cocoon.git"

# Autenticación y roles
gem "devise"
gem "devise-i18n"
gem "cancancan"
gem "bcrypt"

# Listados en páginas
gem "will_paginate"

# ICU con CLDR
gem 'twitter_cldr'

# Maneja adjuntos
gem "paperclip"

# Zonas horarias
gem "tzinfo"
gem "tzinfo-data"

# Motor SIP
gem 'sip', git: "https://github.com/pasosdeJesus/sip.git"
#gem 'sip', path: '../sip'

# Motor de SIVeL 2
gem 'sivel2_gen', git: "https://github.com/pasosdeJesus/sivel2_gen.git"
#gem 'sivel2_gen', path: '../sivel2_gen'

# Motor de SIVeL 2 - SJR
gem 'sivel2_sjr', git: "https://github.com/pasosdeJesus/sivel2_sjr.git"
#gem 'sivel2_sjr', path: '../sivel2_sjr'

# Motor Cor1440_gen
gem 'cor1440_gen', git: "https://github.com/pasosdeJesus/cor1440_gen.git"
#gem "cor1440_gen", path: '../cor1440_gen'

# Motor sal7711_gen 
gem 'sal7711_gen', git: "https://github.com/pasosdeJesus/sal7711_gen.git"
#gem "sal7711_gen", path: '../sal7711_gen'

# Motor sal7711_web
gem 'sal7711_web', git: "https://github.com/pasosdeJesus/sal7711_web.git"
#gem "sal7711_web", path: '../sal7711_web'

group :doc do
    # Genera documentación en doc/api con bundle exec rake doc:rails
    gem "sdoc", require: false
end

# Los siguientes son para desarrollo o para pruebas con generadores
group :development do
  # Depurar
  #gem "byebug"
  
  # Consola irb en páginas con excepciones o usando <%= console %> en vistasA
  gem 'web-console'

end

# Los siguientes son para pruebas y no tiene generadores requeridos en desarrollo
group :test do
  # Acelera desarrollo ejecutando en fondo.  https://github.com/jonleighton/spring
  gem "spring"

  # Pruebas con rspec
  gem 'spring-commands-rspec'
  gem 'rspec-rails'

  gem 'rails-controller-testing'

  # Un proceso para cada prueba -- acelera
  gem 'spork'

  # Maneja datos de prueba
  gem "factory_girl_rails", group: [:development, :test]

  # https://www.relishapp.com/womply/rails-style-guide/docs/developing-rails-applications/bundler
  # Lanza programas para examinar resultados
  #gem "launchy"

  # Pruebas de regresión que no requieren javascript
  gem "capybara"
  
  # Pruebas de regresión que requieren javascript
  gem "capybara-webkit"

  # Envia resultados de pruebas desde travis a codeclimate
  gem "codeclimate-test-reporter", require: nil

  # Para examinar errores, usar "rescue rspec" en lugar de "rspec"
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :production do
  # Para despliegue
  gem "unicorn"

  # Requerido por heroku para usar stdout como bitacora
  gem "rails_12factor"
end

group :staging do
    gem "newrelic_rpm"
end
