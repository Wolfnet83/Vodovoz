class CreateCdrs < ActiveRecord::Migration
  def change
    create_table :cdrs do |t|

      t.timestamps
    end
  end
end
