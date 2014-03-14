class AddColumnsToAccount < ActiveRecord::Migration
  def change
	add_column :accounts, :organization, :string
  	add_column :accounts, :space, :string
	add_column :accounts, :codenum, :string
  end
end
