include HttpHelper
class Iaas::CmpPublicIpController < ApplicationController

	def index
		all_natip =  CmpNatip.all
	  render xml: all_natip	
	end

	def query_by_ownername 
		ownername = params[:id]
		owner = CmpOwner.find_by ownername: ownername
		owner_natip = get_natip_by_owner owner
		render xml: owner_natip
	end
	
	def apply
		#receive params
		subnet_name = params[:subnetName]
		owner_name = params[:ownerName]

		#find subnet by name
		subnet = CmpSubnet.find_by name: subnet_name

		#find owner by name
		owner = CmpOwner.find_by ownername: owner_name

		#externalid
		externalId ||= 'externalId'

		#rest apply pulbic ip
		method = :post
		path = '/network/publicip'

		ip_hash = {}
		hash_root = :applyPublicipRequest

		ip_hash[:subnetId] = subnet.id
		ip_hash[:owner] = owner.owner
		ip_hash[:externalId] = externalId

		con = Connection.new
		req,res = con.request method,path,{hash_root => ip_hash},true

		ip_res = Hash.from_xml res.body
		ip_res = ip_res['applyPublicipResponse']
    puts ip_res
		render xml: {:req => req.body ,:res => res.body}

	end

	def release
		#receive params
		nat_ip = params[:natip]

		#rest release
		method = :delete
		path = "/network/publicip/#{nat_ip}"
		
		con = Connection.new
		req,res = con.request method,path,nil,true

		render xml: {:req => req.body ,:res => res.body}

	end

	def binding
		#receive params
		ip = params[:ip]
		nat_ip = params[:natip]
		unbinding = params[:unbinding]

		#rest binding
		method = unbinding.nil? ? (:post) : (:delete)
		path = "/network/publicip/binding/#{ip}/#{nat_ip}"

		con = Connection.new
		req,res = con.request method,path,nil,true

		render xml: {:req => req.body ,:res => res.body}

	end

	def bandwidth
		#without externalid
		#receive params
		nat_ip = params[:natip]
		method = params[:behavior].to_sym

		path = "/network/bandwidth/ip/#{nat_ip}"
		
		hash_root = {
			:post => :applyBandwidthRequest,
			:put => :modifyBandwidthRequest
		}


		case method
		when :delete
			request_hash = nil
		else
			ownername = params[:ownername]
			bandwidth = params[:bandwidth]
			description = params[:description]
			request_hash = {hash_root[method] =>{:owner => owner.owner,
																					 :bandwidth => bandwidth,
																					 :description => description}}
		end

		con = Connection.new
		req,res = con.request method,path,request_hash,true

	end

	def detail
		#receive params
		nat_ip = params[:natip]

		#find ip entry
		ip_entry = CmpNatip.find_by natip: nat_ip

		#other info
		#todo

		render xml: ip_entry
	end

	def query_by_ownername
		ownername = params[:id]
		owner = CmpOwner.find_by ownername: ownername
		ip_entries = CmpNatip.where owner: owner.owner
		render xml: ip_entries
	end

end
