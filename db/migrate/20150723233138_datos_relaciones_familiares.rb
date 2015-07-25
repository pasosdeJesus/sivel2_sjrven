class DatosRelacionesFamiliares < ActiveRecord::Migration
  def up
    execute <<-SQL
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('SI', 'SIN INFORMACION', NULL, '2001-01-01', NULL, NULL, NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('SO', 'ESPOSA(O)/COMPAÑERA(O)', '', '2001-01-01', NULL, 'SO', NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('AB', 'ABUELA(O)', NULL, '2001-01-01', NULL, 'AB', NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('NO', 'NIETA(O)', NULL, '2014-02-18', NULL, 'AB', NULL, NULL);
      UPDATE sip_trelacion SET inverso='NO' where id='AB';
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('PA', 'MADRE/PADRE', NULL, '2001-01-01', NULL, 'PA', NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('HI', 'HIJA(O)', NULL, '2001-01-01', NULL, 'PA', NULL, NULL);
      UPDATE sip_trelacion SET inverso='HI' where id='PA';
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('HE', 'HERMANA(O)', NULL, '2001-01-01', NULL, 'HE', NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('PO', 'MADRINA/PADRINO', NULL, '2001-01-01', NULL, 'PO', NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('AH', 'AHIJADA(O)', NULL, '2014-02-18', NULL, 'PO', NULL, NULL);
      UPDATE sip_trelacion SET inverso='AH' where id='PO';
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('TO', 'TIA(O)', NULL, '2001-01-01', NULL, 'TO', NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('OO', 'SOBRINA(O)', NULL, '2014-02-18', NULL, 'TO', NULL, NULL);
      UPDATE sip_trelacion SET inverso='OO' where id='TO';
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('PD', 'MADRASTRA(PADRASTRO)', '', '2011-09-21', NULL, 'PD', NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('HO', 'HIJASTRA(O)', '', '2011-05-02', NULL, 'PD', NULL, NULL);
      UPDATE sip_trelacion SET inverso='HO' where id='PD';
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('SG', 'SUEGRA(O)', NULL, '2014-02-18', NULL, 'SG', NULL, NULL);
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('YE', 'NUERA/YERNO', NULL, '2014-02-18', NULL, 'SG', NULL, NULL);
      UPDATE sip_trelacion SET inverso='YE' where id='SG';
      INSERT INTO sip_trelacion (id, nombre, observaciones, fechacreacion, fechadeshabilitacion, inverso, created_at, updated_at) VALUES ('PM', 'PRIMA(O)', NULL, '2014-02-18', NULL, 'PM', NULL, NULL);
    SQL
  end
  def down
    execute "DELETE FROM sip_trelacion"
  end
end
