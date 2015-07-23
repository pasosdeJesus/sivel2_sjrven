# encoding: UTF-8

require 'sivel2_sjr/concerns/models/casosjr'

class Sivel2Sjr::Casosjr < ActiveRecord::Base
  include Sivel2Sjr::Concerns::Models::Casosjr

  belongs_to :statusmigratorio, 
    class_name: "Sivel2Sjr::Statusmigratorio", 
    foreign_key: "id_statusmigratorio", validate: true

end
