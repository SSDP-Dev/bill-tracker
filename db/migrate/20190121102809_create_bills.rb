class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.string :bill_identifier
      t.string :bill_title
      t.string :bill_session
      t.string :bill_jurisdiction
      t.string :bill_id

      t.timestamps
    end
  end
end
