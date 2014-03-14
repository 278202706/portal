include HttpHelper
include CmpModelsHelper
class Iaas::CmpLoadbalanceController < ApplicationController

	def index
		all_lb =  CmpLbpool.all
	  render xml: all_lb	
	end

	def list ownername
		owner = CmpOwner.find_by ownername: ownername
		owner_lb = get_lb_by_owner owner
		render xml: owner_lb
	end
	
	def apply
		#receive params
		owner_name = params[:ownerName]

		protocol = params[:protocol]
		lbIp = params[:lbIp]
		lbStrategy = params[:lbStrategy]
		description = params[:description]
		
		#find owner by name
		owner = CmpOwner.find_by ownername: owner_name

		#externalid
		externalId ||= 'lb_externalId'

		#rest apply pulbic ip
		method = :post
		path = '/network/loadbalance'

		lb_hash = {}
		hash_root = :applyLoadbalanceRequest

		lb_hash[:owner] = owner.owner
		lb_hash[:protocol] = protocol
		lb_hash[:lbIp] =lbIp
		lb_hash[:lbStrategy] =lbStrategy
		lb_hash[:description] = description
		lb_hash[:externalId] = externalId

		req,res = Connection.restreq method,path,{hash_root => lb_hash},true
		render xml: {:req => req.body ,:res => res.body}

	end

	#update service or delelete
	def manage_service
		#receive params
		method = params[:behavior].to_sym
		lbIp = params[:lbIp]

		#find lbid by ip
		lbid = find_lbid_by_ip lbIp

		#path
		path = "/network/loadbalance/manage/#{lbid}"

		lb_hash = nil

		if method == :put
			lb_hash ={:modifyLoadbalanceRequest =>{
			             :lbStrategy => params[:lbStrategy]
			             }
			}
		end

		#rest api
		req,res = Connection.restreq method,path,lb_hash,true

		render xml: {:req => req.body ,:res => res.body}

	end

	#add or delete
	def manage_object
		#receive params
		method = params[:behavior].to_sym
		path = "/network/loadbalance/ip"

		hash_root ={ :post => :addLbpooEntryRequest ,
		             :delete => :removeLbpooEntryRequest}  
	  ipList = [] 
    ip_array = params[:iplist]

    ip_array.each do |ip|
      ipList << {:ip => ip}
    end
		lbIp = params[:lbip]
		lbid = find_lbid_by_ip lbIp

		lb_hash = {:lbId => lbid }
    lb_ahash =[{:root =>'ipList',:array => ipList}]
		req,res = Connection.restreq method,path,{hash_root[method] => lb_hash },true,lb_ahash

		render xml: {:req => req.body ,:res => res.body}

	end

	def detail
		#receive params
		ip = params[:ip]
		lb = CmpLdpool.find_by proxyip: ip
		render xml: lb
	end

	def query_by_containername
		containername = params[:id] 
		container = CmpOwnercontainer.find_by name: containername
		lbpools = CmpLbpool.where owner: container.owner
		render xml: lbpools
	end
end
