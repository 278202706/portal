class CreateOrglocals < ActiveRecord::Migration
  def change
    create_table :orglocals do |t|
	  t.string :name
	  t.string :guid
      t.timestamps
    end
  end
end
