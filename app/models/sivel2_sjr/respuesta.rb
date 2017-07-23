# encoding: UTF-8

require 'sivel2_sjr/concerns/models/respuesta'
module Sivel2Sjr
  class Respuesta < ActiveRecord::Base
    include Sivel2Sjr::Concerns::Models::Respuesta

    has_many :emprendimiento_respuesta, 
      class_name: "EmprendimientoRespuesta",  
      foreign_key: "id_respuesta", dependent: :destroy, validate: true
    has_many :emprendimiento, class_name: "Emprendimiento", 
      :through => :emprendimiento_respuesta
    accepts_nested_attributes_for :emprendimiento_respuesta, 
      reject_if: :all_blank, update_only: true

    has_many :aspsicosocial_respuesta, 
      class_name: "AspsicosocialRespuesta",  
      foreign_key: "id_respuesta", dependent: :destroy, validate: true
    has_many :aspsicosocial, class_name: "Aspsicosocial", 
      :through => :aspsicosocial_respuesta
    accepts_nested_attributes_for :aspsicosocial_respuesta, 
      reject_if: :all_blank, update_only: true


  end
end
