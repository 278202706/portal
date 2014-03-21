class CreateAppstartpros < ActiveRecord::Migration
  def change
    create_table :appstartpros do |t|
      t.string :username
      t.string :appid
      t.string :token
      t.string :log
      t.timestamps
    end
  end
end
