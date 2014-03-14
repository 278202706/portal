include HttpHelper
include VlanHelper
class Iaas::CmpOwnercontainerController < ApplicationController

	def index
		containers =  CmpOwnercontainer.all
	  render xml: containers	
	end
	
	def create
		#receive params

		#apply vlan
		method = :post
		path = '/network/vlan'

		vlan_hash ={}
		hash_root = :applyVlanRequest
		
		subnet = CmpSubnet.find_by name: params[:subnetName]
		vlan_hash[:subnetId] = subnet.id || '8a81c6d64095deb501409ae97b6b02e5'
		
		owner = CmpOwner.find_by ownername: params[:ownerName]
		vlan_hash[:owner] = owner.owner

		vlan_hash[:capacity] = params[:capacity]

		con = Connection.new
		req,res = con.request method,path,{hash_root => vlan_hash},true

		puts res.body
		vlan_res = Hash.from_xml res.body
		vlan_res = vlan_res['applyVlanResponse']

		uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
		cmp_ownercontainer = CmpOwnercontainer.create(:id  => uuid,:name => params[:name],
																							  :ownerid => owner.id,
																							  :vlanid => vlan_res['vlanId'],
																								:subnetid => vlan_hash[:subnetId],
																								:maxservernum => vlan_hash[:capacity],
																								:presentservernum => 0,
																								:owner => owner.owner,
																								:description => params[:description]	||	"description"
																							 )
	 cmp_ownercontainer.save


	 render xml: {:req => req.body ,:res => res.body}

	end

	def update
		#receive params
	  old_name = params[:old_name]
		new_name = params[:new_name]
		
		#find container
		cmp_ownercontainer = CmpOwnercontainer.find_by name: old_name

		#modify
		cmp_ownercontainer.name = new_name
		cmp_ownercontainer.description = params[:description]
		cmp_ownercontainer.save

		render xml: cmp_ownercontainer

	end

	def delete
		#receive params
		container_name = params[:name]

		#find container
		cmp_ownercontainer = CmpOwnercontainer.find_by name: container_name

		#release vlan
		vlan_id = cmp_ownercontainer.vlanid
		method = :delete
		path = "/network/vlan/delete/#{vlan_id}" 
		con = Connection.new
		req,res = con.request method,path,nil,true

		#delete container
		cmp_ownercontainer.destroy
		render xml: {:req => req.body ,:res => res.body}
	end

	def detail
		container_name = params[:containerName] || 'vlanID1'
		container = CmpOwnercontainer.find_by name: container_name
		render xml: container
	end

	def query_by_ownername
		ownername = params[:id]
		owner = CmpOwner.find_by ownername: ownername
		containers = CmpOwnercontainer.where owner: owner.owner
		render xml: containers
	end

end
