class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.text :collection_hash

      t.timestamps
    end
  end
end
