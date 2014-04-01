#encoding: utf-8
module MointorHelper
  #require 'net/http'
  BASEURI="http://10.1.29.124:18080"

  def base_request url
    begin
      p url
      uri = URI(url)
      Net::HTTP.get(uri)
    rescue
     # "Net::HTTP.get error!"
     nil
    end
  end

  def base_get url
    resp = base_request url
    if resp
      JSON.parse resp
    else
      nil
    end
  end

  def get_componentinfo
    begin
      base_get "#{BASEURI}/paasdata/componentinfo"
    rescue
      nil
    end
  end

  def get_appinfo
    begin
      base_get "#{BASEURI}/paasdata/appinstanceinfo"
    end
  end

  def get_machineinfo
    begin
      base_get "#{BASEURI}/guardianlist"
    end
  end

  def ip_port url
    if url =~ /:/
      return $`, $'
    end
  end

  def to_date s
    times = s.split(":")
    newtime = ""
    times.each do |time|
      unit = case
        when (time.include? "d")
          "天"
        when (time.include? "h")
          "小时"
        when (time.include? "m")
          "分"
        when (time.include? "s")
          "秒"
      end
      newtime += "#{time[0...-1]}#{unit}"
    end
    newtime
  end

  def to_time s
    "#{s[0..9]} #{s[11..18]}"
  end

  def second_to_date s
    date = ""
    days = s.to_i/86400
    hours = (s.to_i-days*86400)/3600
    minutes = (s.to_i-days*86400-hours*3600)/60
    seconds = s.to_i-days*86400-hours*3600-minutes*60
    date = "#{days}天#{hours}小时#{minutes}分#{seconds}秒"
  end

  def bit_to_Mb bit
    (bit.to_i/1048576.0).round(2)    
  end
  
  def RundataApp.find_latest_data size
     find(:all, :conditions => ["appinstanceid= ? ", @appinstanceid], 
          :order => "collecttime DESC", 
          :limit => size,
          :select=> "collecttime, usage_cpu, usage_disk, usage_mem")
  end

  def to_mdata s
    "#{s[0..3]}-#{s[4..5]}-#{s[6..7]} #{s[8..9]}:#{s[10..11]}:#{s[12..13]}"
  end

  def fetch_machinedisk_rundata ip
    rundata_num = 360
    offset = 12
    machinedisk_rundata = RundataMachinedisk.find(:all, :conditions => ["ipaddr= ? ", ip], :order => "collecttime DESC", :limit => rundata_num, :select=> "collecttime, dreads")
    rundata = Array.new
    machinedisk_reads = Array.new
    j = 0

    0.upto(rundata_num-1) do |i|
      if i% offset == 0
        if machinedisk_rundata[i] !=nil
          rundata[j] = RundataMachinedisk.new
          rundata[j] = machinedisk_rundata[i]
          machinedisk_reads[j] = rundata[j].dreads
        else
          machinedisk_reads[j] = 0
        end
        j+=1
      end
    end

    machinedisk_reads
  end

  def fetch_machinecpu_rundata ip
    rundata_num = 360
    offset = 12
    machinecpu_rundata = RundataMachinecpu.find(:all, :conditions => ["ipaddr= ? ", ip], :order => "collecttime DESC", :limit => rundata_num, :select=> "collecttime, user, total")
    rundata = Array.new
    machinecpu_utilization = Array.new
    j = 0

    0.upto(rundata_num-1) do |i|
      if i% offset == 0
        if machinecpu_rundata[i] !=nil
          rundata[j] = RundataMachinecpu.new
          rundata[j] = machinecpu_rundata[i]
          machinecpu_utilization[j] = rundata[j].user
          machinecpu_utilization[j] = (rundata[j].user.to_f/rundata[j].total)*100
        else
          machinecpu_utilization[j] = 0
        end
        j+=1
      end
    end
    machinecpu_utilization
  end

  def fetch_machinemem_rundata ip
    rundata_num = 360
    offset = 12
    machinemem_rundata = RundataMachinememory.find(:all, :conditions => ["ipaddr= ? ", ip], :order => "collecttime DESC", :limit => rundata_num, :select=> "collecttime, actual_used")
    rundata = Array.new
    machinemem = Array.new
    j = 0

    0.upto(rundata_num-1) do |i|
      if i% offset == 0
        if machinemem_rundata[i] !=nil
          rundata[j] = RundataMachinememory.new
          rundata[j] = machinemem_rundata[i]
          machinemem[j] = bit_to_Mb(rundata[j].actual_used)
        else
          machinemem[j] = 0
        end
        j+=1
      end
    end

    machinemem
  end

end
