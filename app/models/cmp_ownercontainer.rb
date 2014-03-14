class CmpOwnercontainer < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_ownercontainer"
  self.inheritance_column = nil
end
