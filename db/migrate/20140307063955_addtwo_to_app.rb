class AddtwoToApp < ActiveRecord::Migration
  def change
    add_column :apps, :space, :string
  end
end
