class CreaPlanEst1 < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      INSERT INTO cor1440_gen_proyectofinanciero (id, nombre, 
        observaciones, fechainicio, fechacierre, responsable_id, 
        fechacreacion, fechadeshabilitacion, created_at, updated_at, 
        compromisos, monto) 
      VALUES (10, 'PLAN ESTRATÉGICO 1', '', 
        '2019-10-01', NULL, NULL, '2019-10-01', 
        NULL, '2019-10-01', '2019-10-01', 'Acompañar, servir y defender a la población en situación de refugio y desplazamiento', 1);

      INSERT INTO cor1440_gen_objetivopf (id, proyectofinanciero_id, numero, 
        objetivo) VALUES 
        (15, 10, 'OE1', 
        'Acompañar, servir y defender a la población en situación de refugio y desplazamiento');

      INSERT INTO cor1440_gen_resultadopf (id, proyectofinanciero_id, 
        objetivopf_id, numero, resultado) VALUES 
        (15, 10, 15, 'R1', 
        'Acompañar, servir y defender a la población en situación de refugio y desplazamiento');


      INSERT INTO cor1440_gen_actividadpf (id, proyectofinanciero_id, 
        nombrecorto, titulo, 
        descripcion, resultadopf_id, actividadtipo_id) 
      VALUES (10, 10, 'SEGCAS', 'SEGUIMIENTO A CASO', 
      '', 15, NULL);
      INSERT INTO cor1440_gen_actividadpf (id, proyectofinanciero_id, 
        nombrecorto, titulo, 
        descripcion, resultadopf_id, actividadtipo_id) 
        VALUES (11, 10, 'ASHUM', 'ASISTENCIA HUMANITARIA', 
      '', 15, NULL);
      INSERT INTO cor1440_gen_actividadpf (id, proyectofinanciero_id, 
        nombrecorto, titulo, 
        descripcion, resultadopf_id, actividadtipo_id) 
        VALUES (12, 10, 'EMP', 'EMPRENDIMIENTO', 
        '', 15, NULL); 
      INSERT INTO cor1440_gen_actividadpf (id, proyectofinanciero_id, 
        nombrecorto, titulo, 
        descripcion, resultadopf_id, actividadtipo_id) 
        VALUES (13, 10, 'ASPSI', 'ASISTENCIA PSICOSOCIAL', 
        '', 15, NULL); 
      INSERT INTO cor1440_gen_actividadpf (id, proyectofinanciero_id, 
        nombrecorto, titulo, 
        descripcion, resultadopf_id, actividadtipo_id) 
        VALUES (14, 10, 'ASLEG', 'ASISTENCIA LEGAL', 
        '', 15, NULL); 

      SELECT pg_catalog.setval('cor1440_gen_actividadtipo_id_seq', 100, 
        true);

      INSERT INTO cor1440_gen_actividadtipo 
        (id, nombre, fechacreacion, created_at, updated_at)
        VALUES (10, 'SEGUIMIENTO A CASO', 
        '2019-10-11', '2019-10-11', '2019-10-11');
      UPDATE cor1440_gen_actividadpf SET actividadtipo_id=10
        WHERE id=10;
      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('10', 'SEGUIMIENTO A CASO', 'seguimiento_a_caso') ;
      -- Situación encontrada va en descripción del formulrio actividad
      -- Observaciones va en observaciones del formulario actividad
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, tipo, formulario_id, fila) VALUES
        ('100', 'Recomendaciones', 
       'recomendaciones', '1', 10, 1);
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, tipo, formulario_id, fila) VALUES
        ('101', 'Compromisos de la persona', 
       'compromisos_persona', '1', 10, 2);
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, tipo, formulario_id, fila) VALUES
        ('102', 'Compromisos del JRS', 
       'compromisos_jrs', '1', 10, 3);
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('10', '10');


      INSERT INTO cor1440_gen_actividadtipo 
        (id, nombre, fechacreacion, created_at, updated_at)
        VALUES (11, 'ASISTENCIA HUMANITARIA', 
        '2019-10-11', '2019-10-11', '2019-10-11');
      UPDATE cor1440_gen_actividadpf SET actividadtipo_id=11
        WHERE id=11;
      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('11', 'ASISTENCIA HUMANITARIA', 'asistencia_humanitaria') ;
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, tablabasica, formulario_id, fila, ayudauso) VALUES
        ('110', 'Asistencia humanitaria', 'asistencia_humanitaria',
        '14', 'ayudassjr', 11, 1, 'Seleccione el(los) tipo(s) de ayuda brindada por el JRS');
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila, ayudauso) VALUES
        ('111', 'Detalle de asistencia humanitaria', 
          'detalle_asistencia_humanitaria', '1', 11, 2, 
          'Describir la ayuda humanitaria del JRS (campo opcional)');
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila, ayudauso) VALUES
        ('112', 'Monto de la asistencia humanitaria', 
          'monto_asistencia_humanitaria', '3', 11, 3, 
          '');
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('11', '11');


      INSERT INTO cor1440_gen_actividadtipo 
        (id, nombre, fechacreacion, created_at, updated_at)
        VALUES (12, 'EMPRENDIMIENTO', 
        '2019-10-11', '2019-10-11', '2019-10-11');
      UPDATE cor1440_gen_actividadpf SET actividadtipo_id=12
        WHERE id=12;
      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('12', 'EMPRENDIMIENTO', 'emprendimiento') ;
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, tablabasica, formulario_id, fila, ayudauso) VALUES
        ('120', 'Emprendimiento', 'emprendimiento',
        '14', 'emprendimiento', 12, 1, 'Seleccione el(los) tipo(s) de emprendimiento apoyados por el JRS');
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila, ayudauso) VALUES
        ('121', 'Detalle del emprendimiento', 
          'detalle_emprendimiento', '1', 12, 2, 
          'Describir el emprendimiento (opcional)');
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila, ayudauso) VALUES
        ('122', 'Monto del apoyoa para emprendimiento', 
          'monto_emprendimiento', '3', 12, 3, 
          '');
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('12', '12');


      INSERT INTO cor1440_gen_actividadtipo 
        (id, nombre, fechacreacion, created_at, updated_at)
        VALUES (13, 'ASISTENCIA PSICOSOCIAL', 
        '2019-10-11', '2019-10-11', '2019-10-11');
      UPDATE cor1440_gen_actividadpf SET actividadtipo_id=13
        WHERE id=13;
      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('13', 'ASISTENCIA PSICOSOCIAL', 'asistencia_psicosocial') ;
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, tablabasica, formulario_id, fila, ayudauso) VALUES
        ('130', 'Asistencia psicosocial', 'asistencia_humanitaria',
        '14', 'aspsicosocial', 13, 1, 'Seleccione el(los) tipo(s) de asistencia psicosocial brindados por el JRS');
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila, ayudauso) VALUES
        ('131', 'Detalle de asistencia psicosocial', 
          'detalle_asistencia_psicosocial', '1', 13, 2, 
          'Describir la asistencia psicosocial del JRS (campo opcional)');
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila, ayudauso) VALUES
        ('132', 'Monto de la asistencia psicosocial', 
          'monto_asistencia_psicosocial', '3', 13, 3, 
          '');
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('13', '13');

      INSERT INTO cor1440_gen_actividadtipo 
        (id, nombre, fechacreacion, created_at, updated_at)
        VALUES (14, 'ASISTENCIA LEGAL', 
        '2019-10-11', '2019-10-11', '2019-10-11');
      UPDATE cor1440_gen_actividadpf SET actividadtipo_id=14
        WHERE id=14;
      INSERT INTO mr519_gen_formulario (id, nombre, nombreinterno) 
        VALUES('14', 'ASISTENCIA LEGAL', 'asistencia_legal') ;
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, tablabasica, formulario_id, fila, ayudauso) VALUES
        ('140', 'Asistencia legal', 'asistencia_humanitaria',
        '14', 'aslegal', 14, 1, 'Seleccione el(los) tipo(s) de asistencia legal brindados por el JRS');
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila, ayudauso) VALUES
        ('141', 'Detalle de asistencia legal', 
          'detalle_asistencia_legal', '1', 14, 2, 
          'Describir la asistencia legal del JRS (campo opcional)');
      INSERT INTO mr519_gen_campo 
        (id, nombre, nombreinterno, 
          tipo, formulario_id, fila, ayudauso) VALUES
        ('142', 'Monto de la asistencia legal', 
          'monto_asistencia_humanitaria', '3', 14, 3, '');
      INSERT INTO cor1440_gen_actividadtipo_formulario 
        (actividadtipo_id, formulario_id)
        VALUES ('14', '14');


    SQL
  end
  def down
    execute <<-SQL
      DELETE FROM cor1440_gen_actividadpf WHERE (id>='10' AND id<='14');
      DELETE FROM cor1440_gen_actividadtipo_formulario 
        WHERE formulario_id>='10' and formulario_id<='14';
      DELETE FROM mr519_gen_opcioncs
        WHERE campo_id IN (SELECT id FROM mr519_gen_campo
        WHERE formulario_id>='10' and formulario_id<='14');
      DELETE  FROM mr519_gen_campo
        WHERE formulario_id>='10' and formulario_id<='14';
      DELETE FROM mr519_gen_formulario WHERE id>='10' AND id<='14';
      DELETE FROM cor1440_gen_actividadtipo WHERE id>='10' AND id<='14';
      DELETE FROM cor1440_gen_resultadopf WHERE id='15';
      DELETE FROM cor1440_gen_objetivopf WHERE id='15';
      DELETE FROM cor1440_gen_proyectofinanciero WHERE id='10';
    SQL
  end
end
