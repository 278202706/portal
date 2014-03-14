include HttpHelper
module VlanHelper

	#apply vlan
	def apply vlan_hash
		method = :post
		path = "/network/vlan"
		hash_root = :applyVlanRequest
		res,req = Connection.restreq method,path,{hash_root => vlan_hash},true
	end

	#release vlan
	def release vlan_id
		method = :delete
		path = "/network/vlan/delete/#{vlan_id}"
		res,req = Connection.restreq method,path,nil,true
	end

	#apply ip in vlan
	def apply_ip vlan_ip_hash
		method = :post
		path = "/network/vlan/ip"
		hash_root = :vlanIpRequest
		res,req = Connection.restreq method,path,{hash_root => vlan_ip_hash},true
	end

	#modify or release ip in vlan
	def hander_ip method,ip,vlan_ip_hash = nil
		method = method.to_sym
		path = "/network/vlan/ip/#{ip}"
		params_hash = nil
		params_hash = {:ModifyVlanIpRequest => vlan_ip_hash} if method == :put
		res,req = Connection.restreq method,path,params_hash,true
	end
	
end
