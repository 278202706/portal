module MointorHelper
  #require 'net/http'
  BASEURI="http://192.168.0.92:18080"

  def base_request url
    begin
      p url
      uri = URI(url)
      Net::HTTP.get(uri)
    rescue
      "Net::HTTP.get error!"
    end
  end

  def base_get url
    resp = base_request url
    if resp
      JSON.parse resp
    else
      "JSON.parse error!"
    end
  end

  def get_componentinfo
    begin
      base_get "#{BASEURI}/paasdata/componentinfo"
    rescue
      "not get!"
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
end
