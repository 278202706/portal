#encoding: utf-8
module MointorHelper
  #require 'net/http'
  BASEURI="http://192.168.0.92:18080"

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
  
end
