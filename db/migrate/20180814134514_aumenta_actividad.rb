class AumentaActividad < ActiveRecord::Migration[5.2]
  def change
    add_column :cor1440_gen_actividad, :descripcion, :string, limit: 5000
    add_column :cor1440_gen_actividad, :metodologia, :string, limit: 5000
  end
end
