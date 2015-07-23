# encoding: UTF-8

require 'sivel2_sjr/concerns/models/idioma.rb'

module Sivel2Sjr
  class Idioma < ActiveRecord::Base
    include Sivel2Sjr::Concerns::Models::Idioma
  
  	has_many :casosjr, class_name: "Sivel2Sjr::Casosjr", 
      foreign_key: "id_idioma", validate: true
  end
end
