class AdresourceController < ApplicationController
  def dashboard
  end
  def software
  end

  def virtualmac
  end

  def network
  end

  def business
  
  end
  
  def unitcontainer
  
  end
  
  def unitvirmac
  
  end
  def deletebus
    owner=params[:owner]

    require 'net/http'
    require 'uri'
    url = URI("http://127.0.0.1:1238/iaas/cmp_owner/delete")
    response = Net::HTTP.post_form(url,"owner" =>owner)
    @response=response.body
    puts @response+"----------------------------------------------------"
    render json: @response
  end
end
