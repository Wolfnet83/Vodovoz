class CreateAggregatedCalls < ActiveRecord::Migration[5.2]
  def change
    create_table :aggregated_calls do |t|
      t.date     :calldate
      t.integer  :quantity_all
      t.integer  :quantity_in
      t.integer  :quantity_out
      t.integer  :received
      t.integer  :missed

      t.index ["calldate"], name: "index_aggregated_calls_by_calldate", unique: true
    end
  end
end
