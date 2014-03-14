class CreateAppcodes < ActiveRecord::Migration
  def change
    create_table :appcodes do |t|
      t.string :appguid
      t.string :zipname
      t.string :size
      t.string :userguid
      t.string :username
      t.string :appname
      t.string :version
      t.boolean :active
      t.datetime :uploaddate
      t.string :appdetect
      t.timestamps
    end
  end
end
