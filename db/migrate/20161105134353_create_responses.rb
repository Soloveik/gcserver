class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.references :owner
      t.references :target
      t.integer :request_id
      t.string :location
      t.timestamps
    end
  end
end
