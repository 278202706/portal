class RundataApp1m < ActiveRecord::Base
  establish_connection :rundata
  self.table_name = "rundata_app_1d"
end
