class RenombraIdSeq4 < ActiveRecord::Migration
  @@tablas = [
      'emprendimiento',  
      'aspsicosocial',  
  ]

  def up
    @@tablas.each do |t|
        execute <<-SQL
            ALTER SEQUENCE #{t + '_seq'}
                RENAME TO #{t + '_id_seq'};
        SQL
    end
  end

  def down
    @@tablas.each do |t|
        execute <<-SQL
            ALTER SEQUENCE #{t}_id_seq 
                RENAME TO #{t}_seq;
        SQL
    end
  end
end
