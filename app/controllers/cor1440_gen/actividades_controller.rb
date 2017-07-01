# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/actividades_controller"

module Cor1440Gen
  class ActividadesController < ApplicationController
    include Cor1440Gen::Concerns::Controllers::ActividadesController

    def self.filtramas(par, ac, current_usuario)
        return ac
    end
  end
end
