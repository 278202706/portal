class CmpNetworkcptip < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_networkcptip"
  self.inheritance_column = nil
end
