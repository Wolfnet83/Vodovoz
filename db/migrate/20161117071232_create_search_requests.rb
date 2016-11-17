class CreateSearchRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :search_requests do |t|
      t.string :username
      t.string :user_phone
      t.string :client_name
      t.string :client_phone

      t.timestamps
    end
    add_index :search_requests, :id
  end
end
