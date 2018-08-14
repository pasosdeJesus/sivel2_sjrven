# encoding: UTF-8

require 'cor1440_gen/concerns/models/actividad'

module Cor1440Gen
  class Actividad < ActiveRecord::Base
    include Cor1440Gen::Concerns::Models::Actividad

    validates :descripcion, length: { maximum: 5000 } 
    validates :metodologia, length: { maximum: 5000 } 
  end
end
