# encoding: UTF-8

require 'cor1440_gen/concerns/models/actividad'

module Cor1440Gen
  class Actividad < ActiveRecord::Base
    include Cor1440Gen::Concerns::Models::Actividad

    validates :descripcion, length: { maximum: 5000 } 
    validates :metodologia, length: { maximum: 5000 } 

    def presenta(atr)
      case atr.to_s
      when 'linea_accion'
        proyecto.inject('') { |memo, r| 
          memo == '' ? r.presenta_nombre : ';' + r.presenta_nombre
        }
      else
        presenta_actividad(atr)
      end
    end
  end
end
