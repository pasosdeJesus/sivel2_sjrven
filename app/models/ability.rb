# encoding: UTF-8
class Ability < Sivel2Sjr::Ability

  BASICAS_PROPIAS = [
    ['', 'emprendimiento'],
    ['', 'aspsicosocial']
  ]
  @@tablasbasicas = Sip::Ability::BASICAS_PROPIAS + 
    Cor1440Gen::Ability::BASICAS_PROPIAS +
    Sivel2Gen::Ability::BASICAS_PROPIAS + 
    Sivel2Sjr::Ability::BASICAS_PROPIAS + 
    BASICAS_PROPIAS  - [
      ['Sip', 'fuenteprensa'],
      ['Sivel2Gen', 'filiacion'],
      ['Sivel2Gen', 'frontera'],
      ['Sivel2Gen', 'intervalo'],
      ['Sivel2Gen', 'organizacion'],
      ['Sivel2Gen', 'pconsolidado'],
      ['Sivel2Gen', 'region'],
      ['Sivel2Gen', 'sectorsocial'],
      ['Sivel2Gen', 'vinculoestado'],
      ['Sivel2Sjr', 'acreditacion']
  ]

  # Lo demas de sivel2_sjr

end

