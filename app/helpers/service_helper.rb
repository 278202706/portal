module ServiceHelper
  def sendapflie disksize
    require 'net/http'
    url = URI("http://10.1.29.121:8000/apply")
    contents = {
        "disk" => disksize
    }.to_json
    response = Net::HTTP.post_form(url,"disk" => disksize)
    @response=response.body
    return @response
  end
end
