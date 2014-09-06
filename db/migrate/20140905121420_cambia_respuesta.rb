#encoding: UTF-8
class CambiaRespuesta < ActiveRecord::Migration
  def up
    #ayudasjr
    execute "ALTER TABLE respuesta 
        ADD COLUMN detallear VARCHAR(5000)"
    execute "ALTER TABLE respuesta 
        ADD COLUMN montoar INTEGER"
    execute "UPDATE respuesta SET detallear=s.r, montoar=s.m
        FROM (SELECT id_respuesta, 
            TRIM(STRING_AGG(ayudasjr_respuesta.detallear, ' ')) AS r,
            SUM(ayudasjr_respuesta.montoar) AS m
            FROM ayudasjr_respuesta
            GROUP BY id_respuesta) AS s 
        WHERE respuesta.id=s.id_respuesta"
    execute "ALTER TABLE ayudasjr_respuesta DROP COLUMN detallear"
    execute "ALTER TABLE ayudasjr_respuesta DROP COLUMN montoar"
    
    # ayudaestado
    execute "ALTER TABLE respuesta 
        ADD COLUMN cantidadayes VARCHAR(50)"
    execute "ALTER TABLE respuesta 
        ADD COLUMN institucionayes VARCHAR(500)"
    execute "UPDATE respuesta SET cantidadayes=s.c, institucionayes=s.i
        FROM (SELECT id_respuesta,
            TRIM(STRING_AGG(cantidad, ' ')) AS c,
            TRIM(STRING_AGG(institucion, ' ')) AS i
            FROM ayudaestado_respuesta GROUP BY id_respuesta) AS s 
        WHERE respuesta.id=s.id_respuesta"
    execute "ALTER TABLE ayudaestado_respuesta DROP COLUMN cantidad"
    
    execute "ALTER TABLE ayudaestado_respuesta DROP COLUMN institucion"

    # derecho
    execute "ALTER TABLE respuesta ADD COLUMN informacionder BOOL"
    execute "ALTER TABLE respuesta ADD COLUMN accionesder VARCHAR(5000)"
    execute "UPDATE respuesta SET informacionder=s.i, accionesder=s.a
        FROM (SELECT id_respuesta, 
            BOOL_OR(informacion) AS i,
            TRIM(STRING_AGG(acciones, ' ')) AS a
            FROM derecho_respuesta GROUP BY id_respuesta) AS s 
        WHERE respuesta.id=s.id_respuesta"
    execute "ALTER TABLE derecho_respuesta DROP COLUMN informacion"
    execute "ALTER TABLE derecho_respuesta DROP COLUMN acciones"
    
    # motivosjr
    execute "ALTER TABLE respuesta 
        ADD COLUMN detallemotivo VARCHAR(5000)"
    execute "UPDATE respuesta SET detallemotivo=s.d 
        FROM (SELECT id_respuesta,
            TRIM(STRING_AGG(detalle, ' ')) AS d
            FROM motivosjr_respuesta GROUP BY id_respuesta) AS s 
        WHERE respuesta.id=s.id_respuesta"
    execute "ALTER TABLE motivosjr_respuesta DROP COLUMN detalle"
    
    # progestado
    execute "ALTER TABLE respuesta 
        ADD COLUMN difobsprog VARCHAR(5000)"
    execute "UPDATE respuesta SET difobsprog=s.d 
        FROM (SELECT id_respuesta,
            TRIM(STRING_AGG(difobs, ' ')) AS d
            FROM progestado_respuesta GROUP BY id_respuesta) AS s 
        WHERE respuesta.id=s.id_respuesta "
    execute "ALTER TABLE progestado_respuesta DROP COLUMN difobs"

    # aslegal
    execute "ALTER TABLE respuesta 
        ADD COLUMN detalleal VARCHAR(5000)"
    execute "ALTER TABLE respuesta 
        ADD COLUMN montoal INTEGER"
    execute "UPDATE respuesta SET detalleal=s.r, montoal=s.m
        FROM (SELECT id_respuesta,
            TRIM(STRING_AGG(detalleal, ' ')) AS r,
            SUM(montoal) AS m
            FROM aslegal_respuesta GROUP BY id_respuesta) AS s 
        WHERE respuesta.id=s.id_respuesta"
    execute "ALTER TABLE aslegal_respuesta DROP COLUMN detalleal"
    execute "ALTER TABLE aslegal_respuesta DROP COLUMN montoal"

    # aspsicosocial
    execute "ALTER TABLE respuesta 
        ADD COLUMN detalleap VARCHAR(5000)"
    execute "ALTER TABLE respuesta 
        ADD COLUMN montoap INTEGER"
    execute "UPDATE respuesta SET detalleap=s.r, montoap=s.m
        FROM (SELECT id_respuesta,
            TRIM(STRING_AGG(detalleap, ' ')) AS r,
            SUM(montoap) AS m
            FROM aspsicosocial_respuesta GROUP BY id_respuesta) AS s 
        WHERE respuesta.id=s.id_respuesta"
    execute "ALTER TABLE aspsicosocial_respuesta DROP COLUMN detalleap"
    execute "ALTER TABLE aspsicosocial_respuesta DROP COLUMN montoap"

  
    # emprendimiento
    execute "ALTER TABLE respuesta 
        ADD COLUMN detalleem VARCHAR(5000)"
    execute "ALTER TABLE respuesta 
        ADD COLUMN montoem INTEGER"
    execute "UPDATE respuesta SET detalleem=s.r, montoem=s.m
        FROM (SELECT id_respuesta,
            TRIM(STRING_AGG(detalleem, ' ')) AS r,
            SUM(montoem) AS m
            FROM emprendimiento_respuesta GROUP BY id_respuesta) AS s 
        WHERE respuesta.id=s.id_respuesta "
    execute "ALTER TABLE emprendimiento_respuesta DROP COLUMN detalleem"
    execute "ALTER TABLE emprendimiento_respuesta DROP COLUMN montoem"


  end
  def down
    raise ActiveRecord::IrreversibleMigration    
  end
end
