# encoding: UTF-8
class Ability < Sivel2Sjr::Ability

  # Este es como el de prueba de sivel2sjr excepto que este tiene 
  # analista de prensa

  ROLADMIN  = 1
  ROLINV    = 2
  ROLDIR    = 3
  ROLCOOR   = 4
  ROLANALI  = 5
  ROLSIST   = 6
  ROLANALIPRENSA = 7

  ROLES = [
    ["Administrador", ROLADMIN], 
    ["Invitado Nacional", ROLINV], 
    ["Director Nacional", ROLDIR], 
    ["Coordinador oficina", ROLCOOR], 
    ["Analista", ROLANALI], 
    ["Sistematizador", ROLSIST],
    ["Analista de Prensa", ROLANALIPRENSA]
  ]

  BASICAS_PROPIAS = [
    ['', 'emprendimiento']
  ]
  
  def tablasbasicas 
    Sip::Ability::BASICAS_PROPIAS + 
      Cor1440Gen::Ability::BASICAS_PROPIAS +
      Sal7711Gen::Ability::BASICAS_PROPIAS + 
      Sivel2Gen::Ability::BASICAS_PROPIAS + 
      Sivel2Sjr::Ability::BASICAS_PROPIAS + 
      BASICAS_PROPIAS  - [
        ['Sip', 'grupo'],
        ['Sivel2Sjr', 'acreditacion'],
        ['Sivel2Sjr', 'ayudaestado'],
        ['Sivel2Sjr', 'clasifdesp'],
        ['Sivel2Sjr', 'comosupo'],
        ['Sivel2Sjr', 'declaroante'],
        ['Sivel2Sjr', 'derecho'],
        ['Sivel2Gen', 'filiacion'],
        ['Sivel2Gen', 'frontera'],
        ['Sivel2Sjr', 'inclusion'],
        ['Sivel2Gen', 'intervalo'],
        ['Sivel2Sjr', 'modalidadtierra'],
        ['Sivel2Sjr', 'motivosjr'],
        ['Sivel2Gen', 'organizacion'],
        ['Sivel2Gen', 'pconsolidado'],
        ['Sivel2Sjr', 'personadesea'],
        ['Sivel2Sjr', 'progestado'],
        ['Sivel2Sjr', 'proteccion'],
        ['Sivel2Gen', 'region'],
        ['Sivel2Gen', 'sectorsocial'],
        ['Sivel2Sjr', 'tipodesp'],
        ['Sivel2Gen', 'vinculoestado']
      ]
  end

  def campos_plantillas 
    a = Cor1440Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.clone
    a['Actividad'][:campos]=a['Actividad'][:campos] + 
      ['descripcion', 'metodologia', 'linea_accion']
    c = Heb412Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.clone.merge(
      Sivel2Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.clone.merge(a) )
    return c
  end

  def initialize(usuario = nil)
    # Sin autenticación puede consultarse información geográfica 
    can :read, [Sip::Pais, Sip::Departamento, Sip::Municipio, Sip::Clase]
    if !usuario || usuario.fechadeshabilitacion
      return
    end
    can :read, Sal7711Gen::Categoriaprensa 
    can :read, Sal7711Gen::Articulo
    can :contar, Sip::Ubicacion
    can :contar, Sivel2Gen::Caso
    can :buscar, Sivel2Gen::Caso
    can :lista, Sivel2Gen::Caso
    can :descarga_anexo, Sip::Anexo
    can :nuevo, Sivel2Sjr::Desplazamiento
    can :nuevo, Sivel2Sjr::Respuesta
    can :nuevo, Sip::Ubicacion
    can :nuevo, Sivel2Gen::Presponsable
    can :nuevo, Sivel2Gen::Victima
    if !usuario.nil? && !usuario.rol.nil? then
      case usuario.rol 
      when Ability::ROLANALIPRENSA
        can :manage, Sal7711Gen::Articulo

        can :read, Heb412Gen::Doc
        can :read, Heb412Gen::Plantillahcm
        can :read, Heb412Gen::Plantillahcr
        can :read, Heb412Gen::Plantilladoc

      when Ability::ROLINV
        cannot :buscar, Sivel2Gen::Caso
        can :read, Sivel2Gen::Caso 

      when Ability::ROLSIST
        can [:update, :create, :destroy], Cor1440Gen::Actividad, 
          oficina: { id: usuario.oficina_id}
        can [:read, :new], Cor1440Gen::Actividad
        can [:index, :read], Cor1440Gen::Proyectofinanciero

        can :read, Heb412Gen::Doc
        can :read, Heb412Gen::Plantillahcm
        can :read, Heb412Gen::Plantillahcr
        can :read, Heb412Gen::Plantilladoc

        can :manage, Sivel2Gen::Acto
        
        can :read, Sivel2Gen::Caso, 
          casosjr: { oficina_id: usuario.oficina_id }
        can [:update, :create, :destroy], Sivel2Gen::Caso, 
          casosjr: { asesor: usuario.id, oficina_id:usuario.oficina_id }
        can :new, Sivel2Gen::Caso 


        can [:new, :create, :read, :index, :edit, :update], 
          Sip::Actorsocial
        can :manage, Sip::Persona

      when Ability::ROLANALI
        can :read, Cor1440Gen::Actividad
        can :new, Cor1440Gen::Actividad
        can [:update, :create, :destroy], Cor1440Gen::Actividad, 
          oficina: { id: usuario.oficina_id}
        can :read, Cor1440Gen::Informe
        can [:index, :read], Cor1440Gen::Proyectofinanciero

        can :read, Heb412Gen::Doc
        can :read, Heb412Gen::Plantillahcm
        can :read, Heb412Gen::Plantillahcr
        can :read, Heb412Gen::Plantilladoc

        can :manage, Sivel2Gen::Acto

        can :read, Sivel2Gen::Caso
        can :new, Sivel2Gen::Caso
        can [:update, :create, :destroy], Sivel2Gen::Caso, 
          casosjr: { oficina_id: usuario.oficina_id }

        can [:new, :create, :read, :index, :edit, :update], 
          Sip::Actorsocial
        can :manage, Sip::Persona

      when Ability::ROLCOOR
        can [:read, :manage], Usuario, oficina: { id: usuario.oficina_id}

        can :manage, Cor1440Gen::Informe
        can :read, Cor1440Gen::Actividad
        can :new, Cor1440Gen::Actividad
        can [:update, :create, :destroy], Cor1440Gen::Actividad, 
          oficina: { id: usuario.oficina_id}
        can [:index, :read], Cor1440Gen::Proyectofinanciero

        can :read, Heb412Gen::Doc
        can :read, Heb412Gen::Plantillahcm
        can :read, Heb412Gen::Plantillahcr
        can :read, Heb412Gen::Plantilladoc

        can :manage, Sivel2Gen::Acto

        can :read, Sivel2Gen::Caso
        can :new, Sivel2Gen::Caso
        can [:update, :create, :destroy, :poneretcomp], Sivel2Gen::Caso, 
          casosjr: { oficina_id: usuario.oficina_id }

        can [:new, :create, :read, :index, :edit, :update], 
          Sip::Actorsocial
        can :manage, Sip::Persona

      when Ability::ROLADMIN, Ability::ROLDIR
        can :manage, ::Usuario

        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can :manage, Cor1440Gen::Proyectofinanciero

        can :manage, Heb412Gen::Doc
        can :manage, Heb412Gen::Plantillahcm
        can :manage, Heb412Gen::Plantillahcr
        can :manage, Heb412Gen::Plantilladoc

        can :manage, Mr519Gen::Formulario

        can :manage, Sal7711Gen::Articulo

        can :manage, Sip::Actorsocial
        can :manage, Sip::Persona

        can :manage, Sivel2Gen::Acto
        can :manage, Sivel2Gen::Caso
        can :manage, :tablasbasicas
        tablasbasicas.each do |t|
          c = Ability.tb_clase(t)
          can :manage, c
        end
      end
    end
  end 

end

