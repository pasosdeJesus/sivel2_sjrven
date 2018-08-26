# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < Heb412Gen::ModelosController

    include Cor1440Gen::Concerns::Controllers::ActividadesController
   
    def atributos_show
      [ :id, 
        :nombre, 
        :fecha_localizada, 
        :lugar, 
        :oficina, 
        :proyectosfinancieros, 
        :proyectos,
        :responsable,
        :corresponsables,
        :actividadpf, 
        :valorcampoact,
        :descripcion, # ven
        :metodologia, # ven
        :listadoasistencia,
        :poblacion,
        :anexos
      ]
        #:actividadareas, 
        #:objetivo,
        #:resultado, 
    end

    # Lista blanca de parametros
    def actividad_params
      lp = [:descripcion, :metodologia] + lista_params 
      params.require(:actividad).permit(lp)
    end
  end
end
