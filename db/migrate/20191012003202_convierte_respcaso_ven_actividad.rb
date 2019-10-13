class ConvierteRespcasoVenActividad < ActiveRecord::Migration[6.0]
  def up
    Sivel2Sjr::Respuesta.all.each do |r|
      a = Cor1440Gen::Actividad.create(
        nombre: "Respuesta al caso #{r.id_caso} del #{r.fechaatencion}",
        fecha: r.fechaatencion,
        oficina_id: r.caso.casosjr.oficina_id,
        descripcion: r.descamp,
        observaciones: r.observaciones,
        usuario_id: r.caso.casosjr.asesor
      )
      a.casosjr_ids = [r.id_caso]
      a.proyectofinanciero_ids = [10]
      a.actividadpf_ids = [10] 

      a.save
     
      rf = Mr519Gen::Respuestafor.create(
       formulario_id: 10, # Seguimiento a caso
       fechaini: r.fechaatencion,
       fechacambio: r.fechaatencion
      )
      a.respuestafor_ids = [rf.id]
      Mr519Gen::Valorcampo.create(
        campo_id: 100,
        respuestafor_id: rf.id,
        valor: r.orientaciones
      )
      Mr519Gen::Valorcampo.create(
        campo_id: 101,
        respuestafor_id: rf.id,
        valor: r.compromisos
      )
      Mr519Gen::Valorcampo.create(
        campo_id: 102,
        respuestafor_id: rf.id,
        valor: r.gestionessjr
      )

      if r.ayudasjr.count > 0 || (r.detallear && r.detallear != '')
        a.actividadpf_ids += [11]  # No funcionó con a.actividadpf_ids << 11
        rf = Mr519Gen::Respuestafor.create(
          formulario_id: 11, # Asistencia humanitaria
          fechaini: r.fechaatencion,
          fechacambio: r.fechaatencion
        )
        a.respuestafor_ids += [rf.id]
        Mr519Gen::Valorcampo.create(
          campo_id: 110,
          respuestafor_id: rf.id,
          valorjson: r.ayudasjr_ids.map(&:to_s)
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 111,
          respuestafor_id: rf.id,
          valor: r.detallear
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 112,
          respuestafor_id: rf.id,
          valor: r.montoar
        )
      end

      if r.emprendimiento.count > 0 || (r.detalleem && r.detalleem != '')
        a.actividadpf_ids += [12]
        rf = Mr519Gen::Respuestafor.create(
          formulario_id: 12, # Emprendimiento
          fechaini: r.fechaatencion,
          fechacambio: r.fechaatencion
        )
        a.respuestafor_ids += [rf.id]
        Mr519Gen::Valorcampo.create(
          campo_id: 120,
          respuestafor_id: rf.id,
          valorjson: r.emprendimiento_ids.map(&:to_s)
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 121,
          respuestafor_id: rf.id,
          valor: r.detalleem
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 122,
          respuestafor_id: rf.id,
          valor: r.montoem
        )
      end


      if r.aspsicosocial.count > 0 || (r.detalleap && r.detalleap != '')
        a.actividadpf_ids += [13]
        rf = Mr519Gen::Respuestafor.create(
          formulario_id: 13, # Asistencia psicosocial
          fechaini: r.fechaatencion,
          fechacambio: r.fechaatencion
        )
        a.respuestafor_ids += [rf.id]
        Mr519Gen::Valorcampo.create(
          campo_id: 130,
          respuestafor_id: rf.id,
          valorjson: r.aspsicosocial_ids.map(&:to_s)
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 131,
          respuestafor_id: rf.id,
          valor: r.detalleap
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 132,
          respuestafor_id: rf.id,
          valor: r.montoap
        )
      end

      if r.aslegal.count > 0 || (r.detalleal && r.detalleal != '')
        a.actividadpf_ids += [14]
        rf = Mr519Gen::Respuestafor.create(
          formulario_id: 14, # Asistencia legal 
          fechaini: r.fechaatencion,
          fechacambio: r.fechaatencion
        )
        a.respuestafor_ids += [rf.id]
        Mr519Gen::Valorcampo.create(
          campo_id: 140,
          respuestafor_id: rf.id,
          valorjson: r.aslegal_ids.map(&:to_s)
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 141,
          respuestafor_id: rf.id,
          valor: r.detalleal
        )
        Mr519Gen::Valorcampo.create(
          campo_id: 142,
          respuestafor_id: rf.id,
          valor: r.montoal
        )
      end

      a.save
    end
  end

  def down
    execute <<-SQL
      DELETE FROM mr519_gen_valorcampo WHERE 
        respuestafor_id IN (SELECT id FROM mr519_gen_respuestafor
        WHERE formulario_id>=10 AND formulario_id<=14);

      DELETE FROM cor1440_gen_actividad_respuestafor WHERE 
        respuestafor_id IN (SELECT id FROM mr519_gen_respuestafor
        WHERE formulario_id>=10 AND formulario_id<=14);

      DELETE FROM mr519_gen_respuestafor WHERE 
        formulario_id>=10 AND formulario_id<=14;

      DELETE FROM cor1440_gen_actividad_proyectofinanciero WHERE 
        actividad_id IN (SELECT id FROM cor1440_gen_actividad
          WHERE nombre LIKE 'Respuesta al caso%');

      DELETE FROM cor1440_gen_actividad_actividadpf WHERE 
        actividad_id IN (SELECT id FROM cor1440_gen_actividad
          WHERE nombre LIKE 'Respuesta al caso%');

      DELETE FROM sivel2_sjr_actividad_casosjr WHERE 
        actividad_id IN (SELECT id FROM cor1440_gen_actividad
          WHERE nombre LIKE 'Respuesta al caso%');

      DELETE FROM cor1440_gen_actividad WHERE nombre 
        LIKE 'Respuesta al caso%';
    SQL
  end
end
