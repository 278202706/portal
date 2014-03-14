class CreateServicelists < ActiveRecord::Migration
  def change
    create_table :servicelists do |t|
      t.string :userguid
      t.string :username
      t.string :name
      t.string :type
      t.string :plan
      t.datetime :apply_at
      t.datetime :approve_at
      t.datetime :reject_at
      t.boolean :active
      t.timestamps
    end
  end
end
