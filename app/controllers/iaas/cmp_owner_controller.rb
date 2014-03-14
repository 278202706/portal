include HttpHelper
class Iaas::CmpOwnerController < Iaas::CmpAppController
skip_before_action :verify_authenticity_token
	def index
		syses =CmpOwner.all
	  render xml: syses
    #render json: "syses"
	end
	
	def create
		method = :post
		path = '/common/owner'

		owner_hash ={}
		hash_root = :createOwnerRequest
		owner_hash[:type] = params[:type] || 1
		owner_hash[:ownerName] = params[:ownerName] || "owner-test"
		owner_hash[:status] = params[:status] || 2
    owner_hash[:externalId] = params[:externalId] || "external"
		con = Connection.new
		req,res = con.request method,path,{hash_root => owner_hash},true
		owner = CmpOwner.find_by ownername: owner_hash[:ownerName]
    if owner.nil?
      result = -1
    else
      owner.status= owner_hash[:status]
      owner.save
      result = owner.owner
    end
    render_with_inner result
  end

	def update
		method = :put
		
		owner_hash ={}
		hash_root = :modifyOwnerRequest
		owner_hash[:type] = params[:type] || 1
		owner_hash[:ownerName] = params[:ownerName] || "owner-test"
		owner_hash[:status] = params[:status] || 2
		owner_hash[:externalId] = params[:externalId] || "externalupdate"

		owner = CmpOwner.find_by ownername: owner_hash[:ownerName]
		path = "/common/owner/#{owner.owner}"

		puts path
		con = Connection.new
		req,res = con.request method,path,{hash_root => owner_hash},true

		render xml: {:req => req.body ,:res => res.body}

	end

	def delete
		method = :delete

		owner = params[:owner]
		#owner = CmpOwner.find_by ownername: ownername
		path = "/common/owner/#{owner}" 
		con = Connection.new
		req,res = con.request method,path,nil,true

    render json: true
		#render xml: {:req => req.body ,:res => res.body}
	end

	def detail
		owner_owner = params[:owner] || "c737b92d26d644d58831d6cee4a84a45"
		owner = CmpOwner.find_by owner: owner_owner
    render_with_inner owner
	end
	
	def query_by_externalid
		externalid = params[:id]
		owner = CmpOwner.where externalid: externalid
		render xml: owner
	end

end

