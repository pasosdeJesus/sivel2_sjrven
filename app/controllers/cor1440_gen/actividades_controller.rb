# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < Heb412Gen::ModelosController

    include Cor1440Gen::Concerns::Controllers::ActividadesController
    
    # Lista blanca de parametros
    def actividad_params
      lp = [:descripcion, :metodologia] + lista_params
      params.require(:actividad).permit(lp)
    end
  end
end
