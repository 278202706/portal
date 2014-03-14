class MointorController < ApplicationController
   include MointorHelper
   def index

   end
   def machinemonit
     @machineinfos_json = get_machineinfo
     @machineinfos = @machineinfos_json["guardians"]
   end

   def machinedetail
     @index = params[:id].to_i
     @machineinfos_json = get_machineinfo
     @machineinfos = @machineinfos_json["guardians"]
     @machineinfo = @machineinfos[@index]["machineinfo"]
   end

   def processdetail
     @index = params[:id].to_i
     @machineinfos_json = get_machineinfo
     @machineinfos = @machineinfos_json["guardians"]
     @processes = @machineinfos[@index]["machineinfo"]["proc_list"]
   end

   def networkinterfacedetail
     @index = params[:id].to_i
     @machineinfos_json = get_machineinfo
     @machineinfos = @machineinfos_json["guardians"]
     @netinterfacelist = @machineinfos[@index]["machineinfo"]["net_interface_list"]
   end

   def componentmonit
     @componentinfos = get_componentinfo
     @ccinfos = @componentinfos.select {|k,v| v["type"]=="CloudController"}
     @deainfos = @componentinfos.select {|k,v| v["type"]=="DEA"}
     @routerinfos = @componentinfos.select {|k,v| v["type"]=="Router"}
     @hminfos = @componentinfos.select {|k,v| v["type"]=="HealthManager"}
     @uaainfos = @componentinfos.select {|k,v| v["type"]=="UAA"}
   end

   def CloudControllerdetail
     @cckey = params[:id]
     @componentinfos = get_componentinfo
     @ccinfo = @componentinfos.fetch(@cckey)
   end

   def DEAdetail
     @deakey = params[:id]
     @componentinfos = get_componentinfo
     @deainfo = @componentinfos.fetch(@deakey)
   end

   def Routerdetail
     @routerkey = params[:id]
     @componentinfos = get_componentinfo
     @routerinfo = @componentinfos.fetch(@routerkey)
   end

   def HealthManagerdetail
     @hmkey = params[:id]
     @componentinfos = get_componentinfo
     @hminfo = @componentinfos.fetch(@hmkey)
   end

   def UAAdetail
     @uaakey = params[:id]
     @componentinfos = get_componentinfo
     @uaainfo = @componentinfos.fetch(@uaakey)
   end

   def appmonit
     @appinsinfos = get_appinfo
   end

   def appinsdetail
     @appinfos = get_appinfo
     @appinsinfo = @appinfos[params[:id]]
     @appdetail=@appinsinfo["stats"]
   end

end
