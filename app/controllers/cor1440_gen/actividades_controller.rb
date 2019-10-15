# encoding: UTF-8
require_dependency "sivel2_sjr/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < Heb412Gen::ModelosController

    include Sivel2Sjr::Concerns::Controllers::ActividadesController
  
    before_action :set_actividad, 
      only: [:show, :edit, :update, :destroy],
      exclude: [:contar]
    load_and_authorize_resource class: Cor1440Gen::Actividad

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

    def self.posibles_nuevaresp
      return {
        ahumanitaria: ['Asistenia humanitaria', 11],
        emprendimiento: ['Emprendimiento', 12],
        apsicosocial: ['Asistencia psicosocial', 13],
        alegal: ['Asistencia legal', 14]
      } 
    end

    # Retorna datos por enviar a nuevo de este controlador
    # desde javascript cuando se añade una respuesta a un caso
    def self.datos_nuevaresp(caso, controller)
      return {
        nombre: "Seguimiento/Respuesta a caso #{caso.id}",
        oficina_id: caso.casosjr.oficina_id,
        caso_id: caso.id, 
        proyecto_id: 101,
        usuario_id: controller.current_usuario.id 
      } 
    end

    def self.pf_planest_id
      10
    end
    
    def self.actividadpf_segcas_id
      10
    end

    # Lista blanca de parametros
    def actividad_params
      lp = [:descripcion, :metodologia] + lista_params 
      params.require(:actividad).permit(lp)
    end
  end
end
