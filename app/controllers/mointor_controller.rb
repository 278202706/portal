class MointorController < ApplicationController
   include MointorHelper
   def index

   end
   def machinemonit
     @machineinfos_json = get_machineinfo
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
     if @componentinfos
     @ccinfos = @componentinfos.select {|k,v| v["type"]=="CloudController"}
     @deainfos = @componentinfos.select {|k,v| v["type"]=="DEA"}
     @routerinfos = @componentinfos.select {|k,v| v["type"]=="Router"}
     @hminfos = @componentinfos.select {|k,v| v["type"]=="HealthManager"}
     @uaainfos = @componentinfos.select {|k,v| v["type"]=="UAA"}
     else
       @ccinfos = nil
       @deainfos = nil
       @routerinfos = nil
       @hminfos = nil
       @uaainfos = nil
     end
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
     
     @appinstanceid=@appinsinfo["instance"] 
     #@rundata = RundataApp.find(:first)
     rundata_num = 360
     @top_rundata = RundataApp.find(:all, :conditions => ["appinstanceid= ? ", @appinstanceid], :order => "collecttime DESC", :limit => rundata_num, :select=> "collecttime, usage_cpu, usage_disk, usage_mem")
     offset = 12 #1分钟
     #@rundata = RundataApp.find_latest_data(rundata_num)
    
     j=0
     @rundata = Array.new
     @mem_rundata = Array.new
     @disk_rundata = Array.new
     @cpu_rundata = Array.new

     0.upto(rundata_num-1) do |i|
        if i% offset == 0
           if @top_rundata[i] !=nil
             @rundata[j] = RundataApp.new
             @rundata[j] = @top_rundata[i]
             @mem_rundata[j] = bit_to_Mb(@rundata[j].usage_mem)
             @disk_rundata[j] = bit_to_Mb(@rundata[j].usage_disk)
             @cpu_rundata[j] = @rundata[j].usage_cpu*100
           else
             @mem_rundata[j] = 0
             @disk_rundata[j] = 0
             @cpu_rundata[j] = 0
           end
           j+=1
        end
     end
     0.upto(j) do |i|

     end

   end

end
