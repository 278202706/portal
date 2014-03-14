class CmpSubnet < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_subnet"
  self.inheritance_column = nil
end
