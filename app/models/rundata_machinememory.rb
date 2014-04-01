class RundataMachinememory < ActiveRecord::Base
  establish_connection :rundata
  self.table_name = "rundata_machinemem"
end
