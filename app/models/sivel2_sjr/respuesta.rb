# encoding: UTF-8

require 'sivel2_sjr/concerns/models/respuesta'
module Sivel2Sjr
  class Respuesta < ActiveRecord::Base
    include Sivel2Sjr::Concerns::Models::Respuesta

    has_and_belongs_to_many :emprendimiento, 
      class_name: "Emprendimiento", 
      foreign_key: "id_respuesta",  
      validate: true,
      association_foreign_key: 'id_emprendimiento',
      join_table: :emprendimiento_respuesta

    has_and_belongs_to_many :aspsicosocial, 
      class_name: "Sivel2Sjr::Aspsicosocial", 
      foreign_key: "id_respuesta", 
      validate: true,
      association_foreign_key: 'id_aspsicosocial',
      join_table: 'sivel2_sjr_aspsicosocial_respuesta'

  end
end
