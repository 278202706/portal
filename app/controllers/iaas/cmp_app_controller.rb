class Iaas::CmpAppController < ApplicationController
  def render_with_inner result
    if params[:_inner] == true || params[:_inner]=='true'
      return result
    else
      render json: result
    end
  end
end
