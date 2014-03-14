class CmpStoragevolume < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_storagevolume"
  self.inheritance_column = nil
end
