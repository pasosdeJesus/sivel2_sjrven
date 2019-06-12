# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < Heb412Gen::ModelosController

    include Cor1440Gen::Concerns::Controllers::ActividadesController
  
    Cor1440Gen.actividadg1 = "Mujeres venezolanas"
    Cor1440Gen.actividadg2 = "Mujeres colombianas"
    Cor1440Gen.actividadg3 = "Hombres venezolanos" 
    Cor1440Gen.actividadg4 = "Hombres colombianos" 

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
        :respuestafor,
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
