class CreateServiceinsts < ActiveRecord::Migration
  def change
    create_table :serviceinsts do |t|
      t.string :userguid
      t.string :username
      t.string :serviceguid
      t.string :name
      t.string :version
      t.string :sertype
      t.string :provider
      t.string :plan
      t.string :org
      t.string :space
      t.timestamps
    end
  end
end
