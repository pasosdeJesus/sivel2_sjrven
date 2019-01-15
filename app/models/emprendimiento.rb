# encoding: UTF-8
class Emprendimiento < ActiveRecord::Base
  include Sip::Basica

  has_and_belongs_to_many :respuesta, 
    class_name: "Sivel2Sjr::Respuesta", 
    foreign_key: "id_emprendimiento", 
    validate: true, 
    association_foreign_key: 'id_respuesta',
    join_table: :emprendimiento_respuesta

  validates :nombre, presence: true, allow_blank: false
  validates :fechacreacion, presence: true, allow_blank: false
end
