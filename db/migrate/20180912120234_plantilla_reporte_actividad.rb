class PlantillaReporteActividad < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      INSERT INTO heb412_gen_plantillahcr (id, 
        ruta, fuente, licencia, 
        vista, nombremenu) VALUES (1, 
        'plantillas/Reporte_de_Actividad.ods', 'JRS Venezuela', '', 
        'Actividad', 'Rerporte de Actividad');

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (1, 1,   'fecha', 'B', 4);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (2, 1, 'oficina', 'D', 4); 
        -- En realidad es la E pero por una celda combinada antes toca ajustar
        -- rspreadsheet no maneja bien celdas combinadas

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (3, 1, 'lugar', 'B', 5);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (4, 1, 'linea_accion', 'D', 5);
        -- En realidad es E

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (5, 1, 
        'convenio_financiado', 'B', 6);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (6, 1, 
        'actividad_de_convenio', 'D', 6); -- en realidad es E


      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (7, 1, 
        'objetivo_convenio_financiero', 'B', 7);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (8, 1, 'responsable', 'D', 7);
        -- en realidad E

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (9, 1, 'corresponsables', 'B', 8);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (10, 1, 'anexo_1_desc', 'B', 9);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (11, 1, 'anexo_2_desc', 'C', 9);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (12, 1, 'anexo_3_desc', 'D', 9);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (13, 1, 'anexo_4_desc', 'E', 9);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (14, 1, 'anexo_5_desc', 'F', 9);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (15, 1, 'nombre', 'B', 10);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (16, 1, 
        'poblacion_hombres_l_g1', 'B', 17);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (17, 1, 
        'poblacion_mujeres_l_g1', 'C', 17);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (18, 1, 
        'poblacion_hombres_r_g1', 'D', 17);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,  
        nombrecampo, columna, fila) VALUES (19, 1, 
        'poblacion_mujeres_r_g1', 'E', 17);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (20, 1, 
        'poblacion_hombres_l_g2', 'B', 18);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (21, 1, 
        'poblacion_mujeres_l_g2', 'C', 18);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (22, 1, 
        'poblacion_hombres_r_g2', 'D', 18);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,  
        nombrecampo, columna, fila) VALUES (23, 1, 
        'poblacion_mujeres_r_g2', 'E', 18);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (24, 1, 
        'poblacion_hombres_l_g3', 'B', 19);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (25, 1, 
        'poblacion_mujeres_l_g3', 'C', 19);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (26, 1, 
        'poblacion_hombres_r_g3', 'D', 19);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,  
        nombrecampo, columna, fila) VALUES (27, 1, 
        'poblacion_mujeres_r_g3', 'E', 19);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (28, 1, 
        'poblacion_hombres_l_g4', 'B', 20);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (29, 1, 
        'poblacion_mujeres_l_g4', 'C', 20);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (30, 1, 
        'poblacion_hombres_r_g4', 'D', 20);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,  
        nombrecampo, columna, fila) VALUES (31, 1, 
        'poblacion_mujeres_r_g4', 'E', 20);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (32, 1, 
        'poblacion_hombres_l_g5', 'B', 21);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (33, 1, 
        'poblacion_mujeres_l_g5', 'C', 21);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (34, 1, 
        'poblacion_hombres_r_g5', 'D', 21);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,  
        nombrecampo, columna, fila) VALUES (35, 1, 
        'poblacion_mujeres_r_g5', 'E', 21);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (36, 1, 
        'poblacion_hombres_l_g6', 'B', 22);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (37, 1, 
        'poblacion_mujeres_l_g6', 'C', 22);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (38, 1, 
        'poblacion_hombres_r_g6', 'D', 22);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,  
        nombrecampo, columna, fila) VALUES (39, 1, 
        'poblacion_mujeres_r_g6', 'E', 22);


      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (40, 1, 'resultado', 'B', 25);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (41, 1, 'observaciones', 'B', 26);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (42, 1, 'descripcion', 'B', 12);

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id, 
        nombrecampo, columna, fila) VALUES (43, 1, 'metodologia', 'B', 13);
    SQL
  end

  def down
    execute <<-SQL
      DELETE from heb412_gen_campoplantillahcr WHERE plantillahcr_id='1';
      DELETE from heb412_gen_plantillahcr WHERE id='1';
    SQL
  end
end
