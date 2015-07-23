class AgregaObservacionesSjrven < ActiveRecord::Migration
  def change

    add_column :emprendimiento, :observaciones, :string, limit: 5000
    add_column :aspsicosocial, :observaciones, :string, limit: 5000
  end
end
