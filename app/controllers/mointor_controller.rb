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
<<<<<<< HEAD
     if @machineinfos != nil
      @machineinfo = @machineinfos[@index]["machineinfo"]
      @machineip = @machineinfos[@index]["ipaddr"]

      @mdisk_rundata = fetch_machinedisk_rundata @machineip
      @mcpu_rundata = fetch_machinecpu_rundata @machineip
      @mmem_rundata = fetch_machinemem_rundata @machineip
     end
=======
     @machineinfo = @machineinfos[@index]["machineinfo"]
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
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
     
<<<<<<< HEAD
     @appinstanceid=@appinsinfo["instance"]

     @now = Time.new
     puts @now
     #get rundata for 1 hour
     @latest_m =  RundataApp.find(:all, :order => "collecttime DESC", :limit => 1, :select=> "collecttime")
     @latest_m =  @latest_m[0].collecttime.utc()
     @rundata_num_1h = 60
     @time_59min_ago = @latest_m - 59 * 60
     puts @time_59min_ago
     @top_rundata_1h = RundataApp.find(:all, :conditions => ["appinstanceid= ? and collecttime >= ?", @appinstanceid, @time_59min_ago.strftime("%Y-%m-%d %H:%M:00")], :order => "collecttime ASC", :select=> "collecttime, usage_cpu, usage_disk, usage_mem")

     @time_1h = Array.new
     @rundata_1h = Array.new
     @mem_rundata_1h = Array.new
     @disk_rundata_1h = Array.new
     @cpu_rundata_1h = Array.new
     j=0
     0.upto(@rundata_num_1h-1) do |i|
         if @top_rundata_1h[j].collecttime != nil && @top_rundata_1h[j].collecttime == (@time_59min_ago + i * 60).strftime("%Y-%m-%d %H:%M:00")
           @time_1h[i] = (@time_59min_ago + i * 60).strftime("%H:%M")
           @mem_rundata_1h[i] = bit_to_Mb(@top_rundata_1h[j].usage_mem)
           @disk_rundata_1h[i] = bit_to_Mb(@top_rundata_1h[j].usage_disk)
           @cpu_rundata_1h[i] = @top_rundata_1h[j].usage_cpu*100
           j += 1
         else
           @time_1h[i] = (@time_59min_ago + i * 60).strftime("%H:%M")
           @mem_rundata_1h[i] = 0
           @disk_rundata_1h[i] = 0
           @cpu_rundata_1h[i] = 0
         end
     end

     #get rundata for 1 day
     @latest_h =  RundataApp1d.find(:all, :order => "collecttime DESC", :limit => 1, :select=> "collecttime")
     @latest_h = @latest_h[0].collecttime.utc()

     @rundata_num_1d = 24
     @time_23h_ago = @latest_h - 23 * 60 * 60
     @top_rundata_1d = RundataApp1d.find(:all, :conditions => ["appinstanceid= ? and collecttime >= ?", @appinstanceid, @time_23h_ago.strftime("%Y-%m-%d %H:00:00")], :order => "collecttime ASC", :select=> "collecttime, usage_cpu, usage_disk, usage_mem")

     @time_1d = Array.new
     @rundata_1d = Array.new
     @mem_rundata_1d = Array.new
     @disk_rundata_1d = Array.new
     @cpu_rundata_1d = Array.new
     j=0
     0.upto(@rundata_num_1d-1) do |i|
        if @top_rundata_1d[j].collecttime != nil && @top_rundata_1d[j].collecttime == (@time_23h_ago + i * 60 * 60).strftime("%Y-%m-%d %H:00:00")
          @time_1d[i] = (@time_23h_ago + i * 60 * 60).strftime("%H:00")
          @mem_rundata_1d[i] = bit_to_Mb(@top_rundata_1d[j].usage_mem)
          @disk_rundata_1d[i] = bit_to_Mb(@top_rundata_1d[j].usage_disk)
          @cpu_rundata_1d[i] = @top_rundata_1d[j].usage_cpu*100
          j += 1
        else
          @time_1d[i] = (@time_23h_ago + i * 60 * 60).strftime("%H:00")
          @mem_rundata_1d[i] = 0
          @disk_rundata_1d[i] = 0
          @cpu_rundata_1d[i] = 0
        end
     end

     #get rundata for 1 mounth
     @latest_d =  RundataApp1m.find(:all, :order => "collecttime DESC", :limit => 1, :select=> "collecttime")
     @latest_d = @latest_d[0].collecttime.utc()

     @rundata_num_1m = 30
     @time_29d_ago = @latest_d - (@rundata_num_1m - 1) * 24 * 60 * 60
     @top_rundata_1m = RundataApp1m.find(:all, :conditions => ["appinstanceid= ? and collecttime >= ?", @appinstanceid, @time_29d_ago.strftime("%Y-%m-%d 00:00:00")], :order => "collecttime ASC", :select=> "collecttime, usage_cpu, usage_disk, usage_mem")

     @time_1m = Array.new
     @rundata_1m = Array.new
     @mem_rundata_1m = Array.new
     @disk_rundata_1m = Array.new
     @cpu_rundata_1m = Array.new
     j=0
     puts @top_rundata_1m[0].collecttime.strftime("%Y-%m-%d")
     0.upto(@rundata_num_1m - 1) do |i|
      if @top_rundata_1m[j].collecttime != nil && @top_rundata_1m[j].collecttime == (@time_29d_ago + i * 24 * 60 * 60).strftime("%Y-%m-%d 00:00:00")
         @time_1m[i] = (@time_29d_ago + i * 24 * 60 * 60).strftime("%m/%d")
         @mem_rundata_1m[i] = bit_to_Mb(@top_rundata_1m[j].usage_mem)
         @disk_rundata_1m[i] = bit_to_Mb(@top_rundata_1m[j].usage_disk)
         @cpu_rundata_1m[i] = @top_rundata_1m[j].usage_cpu*100
         j += 1
       else
         @time_1m[i] = (@time_29d_ago + i * 24 * 60 * 60).strftime("%m/%d")
         @mem_rundata_1m[i] = 0
         @disk_rundata_1m[i] = 0
         @cpu_rundata_1m[i] = 0
       end
     end
   end
=======
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

>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
end
