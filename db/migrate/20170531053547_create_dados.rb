class CreateDados < ActiveRecord::Migration[5.0]
  def change
    create_table :dados do |t|
      t.float :temperatura
      t.float :umidade

      t.timestamps
    end
  end
end
