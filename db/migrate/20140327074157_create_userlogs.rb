class CreateUserlogs < ActiveRecord::Migration
  def change
    create_table :userlogs do |t|
      t.string :username
      t.string :log
      t.timestamps
    end
  end
end
