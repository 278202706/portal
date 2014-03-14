class AddToSerints < ActiveRecord::Migration
  def change
    add_column :serviceinsts, :approvetime, :datetime
  end
end
