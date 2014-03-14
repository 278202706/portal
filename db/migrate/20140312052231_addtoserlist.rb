class Addtoserlist < ActiveRecord::Migration
  def change
    add_column :servicelists, :isrej, :string
  end
end
