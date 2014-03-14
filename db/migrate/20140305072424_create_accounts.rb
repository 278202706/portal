class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
	  t.string :email
      t.string :password
      t.string :username
	  t.string :guid
	  
      t.timestamps
    end
  end
end
