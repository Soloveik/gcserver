class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.references :owner
      t.references :target
      t.timestamps
    end
  end
end
