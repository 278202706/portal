class CmpDroplet < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_droplet"
  self.inheritance_column = nil
end
