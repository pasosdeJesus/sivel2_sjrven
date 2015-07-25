class DatosProyecto < ActiveRecord::Migration
  def up
    execute <<-SQL
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (101, 'ACCIÓN HUMANITARIA', '', NULL, NULL, '', '2015-07-01', NULL, '2015-07-01 16:28:00.948626', '2015-07-01 16:28:00.948626');
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (104, 'INCIDENCIA POLÍTICA', '', NULL, NULL, '', '2015-07-01', NULL, '2015-07-01 16:30:20.222396', '2015-07-01 16:30:20.222396');
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (105, 'INTEGRACIÓN LOCAL', '', NULL, NULL, '', '2015-07-01', NULL, '2015-07-01 16:30:35.161691', '2015-07-01 16:30:35.161691');
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (108, 'PREVENCIÓN', '', NULL, NULL, '', '2015-07-01', NULL, '2015-07-01 16:31:29.726534', '2015-07-01 16:31:29.726534');
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (109, 'PROYECTOS', '', NULL, NULL, '', '2015-07-01', NULL, '2015-07-01 16:32:16.593125', '2015-07-01 16:32:16.593125');
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (112, 'FORTALECIMIENTO INSTITUCIONAL ', '', NULL, NULL, '', '2015-07-15', NULL, '2015-07-15 19:24:10.851455', '2015-07-15 19:24:10.851455');
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (113, 'COMUNICACIONES', '', NULL, NULL, '', '2015-07-15', NULL, '2015-07-15 19:24:45.769515', '2015-07-15 19:24:45.769515');
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (114, 'DIRECCIÓN NACIONAL', '', NULL, NULL, '', '2015-07-15', NULL, '2015-07-15 19:32:11.667547', '2015-07-15 19:32:11.667547');
INSERT INTO cor1440_gen_proyecto (id, nombre, observaciones, fechainicio, fechacierre, resultados, fechacreacion, fechadeshabilitacion, created_at, updated_at) VALUES (115, 'GESTIÓN ADMINISTRATIVA', '', NULL, NULL, '', '2015-07-21', NULL, '2015-07-21 15:30:24.893391', '2015-07-21 15:30:31.300962');
    SQL
  end
  def down
    execute "DELETE FROM cor1440_gen_proyecto";
  end
end
