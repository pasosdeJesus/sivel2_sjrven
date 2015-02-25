# encoding: UTF-8
class AspsicosocialRespuesta < ActiveRecord::Base
  belongs_to :aspsicosocial, class_name: "Aspsicosocial", 
    foreign_key: "id_aspsicosocial", validate: true
  belongs_to :respuesta, class_name: "Sivel2Sjr::Respuesta", 
    foreign_key: "id_respuesta", validate: true
end
