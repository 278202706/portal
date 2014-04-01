class RundataApp1d < ActiveRecord::Base
  establish_connection :rundata
  self.table_name = "rundata_app_1h"
end
