class AddToApp < ActiveRecord::Migration
  def change
    add_column :apps, :org, :string

  end
end
