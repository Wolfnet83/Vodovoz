class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :number
      t.string :name
      t.string :person

      t.timestamps
    end
  end
end
