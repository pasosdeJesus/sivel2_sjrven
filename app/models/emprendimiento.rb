# encoding: UTF-8
class Emprendimiento < ActiveRecord::Base
  include Sip::Basica

  has_many :emprendimiento_respuesta, class_name: "EmprendimientoRespuesta",
    foreign_key: "id_emprendimiento", validate: true, dependent: :destroy
  has_many :respuesta, class_name: "Sivel2Sjr::Respuesta", 
    :through => :emprendimiento_respuesta

  validates :nombre, presence: true, allow_blank: false
  validates :fechacreacion, presence: true, allow_blank: false
end
