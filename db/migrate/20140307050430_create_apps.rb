class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :userguid
      t.string :username
      t.string :appguid
      t.string :zipfilename
      t.string :version
      t.string :appname
      t.string :appframework
      t.boolean :active
      t.datetime :uploaddate
      t.timestamps
    end
  end
end
