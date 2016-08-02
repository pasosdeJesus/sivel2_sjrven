# encoding: UTF-8
class Ability < Sivel2Sjr::Ability

  BASICAS_PROPIAS = [
    ['', 'emprendimiento'],
    ['', 'aspsicosocial']
  ]
  @@tablasbasicas = Sip::Ability::BASICAS_PROPIAS + 
    Cor1440Gen::Ability::BASICAS_PROPIAS +
    Sal7711Gen::Ability::BASICAS_PROPIAS + 
    Sivel2Gen::Ability::BASICAS_PROPIAS + 
    Sivel2Sjr::Ability::BASICAS_PROPIAS + 
    BASICAS_PROPIAS  - [
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


  def initialize(usuario)
    super(usuario)
    can :read, Sal7711Gen::Categoriaprensa 
    if usuario && usuario.rol then
        can :read, Sal7711Gen::Articulo
        case usuario.rol
        when Ability::ROLADMIN, Ability::ROLDIR, Ability::ROLANALI
          can :manage, Sal7711Gen::Articulo
        when Ability::ROLANALIPRENSA, Ability::ROLADMIN, Ability::ROLDIR, Ability::ROLANALI
          can :manage, Sal7711Gen::Articulo
        end
    end
  end 

end

