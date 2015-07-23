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
    BASICAS_PROPIAS

  @@basicas_id_noauto = Sip::Ability::BASICAS_ID_NOAUTO +
    Sivel2Gen::Ability::BASICAS_ID_NOAUTO 

  @@nobasicas_indice_seq_con_id = Sip::Ability::NOBASICAS_INDSEQID +
    Sivel2Gen::Ability::NOBASICAS_INDSEQID 

  @@tablasbasicas_prio = Sip::Ability::BASICAS_PRIO +
    Sivel2Gen::Ability::BASICAS_PRIO +
    Sivel2Sjr::Ability::BASICAS_PRIO

end

