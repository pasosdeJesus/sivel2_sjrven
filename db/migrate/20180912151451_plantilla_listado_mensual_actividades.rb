class PlantillaListadoMensualActividades < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL

      INSERT INTO heb412_gen_plantillahcm (id, 
        ruta, fuente, licencia, vista, nombremenu, filainicial) VALUES (1, 
        'plantillas/Resumen_mensual_de_actividades_realizadas.ods', 
        'JRS Venezuela', '', 'Actividad', 
        'Resumen mensual de actividades realizadas', 8);

      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (223, 1, 'lugar', 'G');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (222, 1, 'fecha', 'F');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (221, 1, 'actividad_de_convenio', 'E');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (218, 1, 'áreas', 'B');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (225, 1, 'id', 'A');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (224, 1, 'poblacion_mujeres_l', 'H');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (226, 1, 'poblacion_mujeres_r', 'I');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (227, 1, 'poblacion_hombres_l', 'J');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (228, 1, 'poblacion_hombres_r', 'K');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (220, 1, 'objetivo_convenio_financiero', 
        'D');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id, 
        nombrecampo, columna) VALUES (219, 1, 'convenio_financiado', 'C');
      

      SELECT pg_catalog.setval('heb412_gen_campoplantillahcm_id_seq', MAX(id))
        FROM  (SELECT 100 AS id UNION SELECT MAX(id) FROM 
        heb412_gen_campoplantillahcm) AS s;

    SQL
  end
  def down
    execute <<-SQL
      DELETE FROM heb412_gen_campoplantillahcm WHERE plantillahcm_id='1';
      DELETE FROM heb412_gen_plantillahcm WHERE id='1'
    SQL
  end
end
