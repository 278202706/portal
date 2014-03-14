include HttpHelper
include CmpModelsHelper
include CmpCommonHelper
include VlanHelper
class Iaas::CmpVguestController < ApplicationController

	def index
		all_guests =  CmpVguest.all
	  render xml: all_guests
	end

	def list containername
		container = CmpOwnercontainer.find_by ownername: containername
		container_guests = get_guests_by_container container
		render xml: container_guests
	end

	def cptpoollist
		containername = params[:containerName]

		container = CmpOwnercontainer.find_by name: containername
		cptpoolidlist = get_cptpoolidlist_by_subnetid container.subnetid
    cptpoollist = []
		cptpoolidlist.each do |id|
			cptpool = CmpComputepool.find_by id: id

		  cptpoollist <<	[cptpool.name , id]
		end
		render xml: cptpoollist
	end
	
	def ostemplatelist
    
    #no api
=begin
		method = :post
		path = "/compute/vm/templatelist"

		cptpoolname = params[:cptpoolname]
		cptpool = CmpComputepool.find_by name: cptpoolname

		hash_root = :getVMTempateRequest
		request_hash = {:vdcId => cptpool.vdcid, :srcType => 1}

		req,res = Connection.restreq method,path,{hash_root => request_hash},true
		render xml: {:req => req.body ,:res => res.body}
=end
    cptpoolname = params[:cptpoolName]
    cptpool = CmpComputepool.find_by name: cptpoolname
    oslist = get_oslist_by_cptpool cptpool
    render xml: oslist

 
	end

	def apply
		#receive params
		method = :post
		path = "/compute/vm"

		vm_keys = [:name, :cpuNum, :memorySize,:diskSize,:scsiNum ,
		           :fchbaNum,:osName,:powerOnAfterCreated,:owner,
		           :externalId, :description]
    # cptpoolIdList & nicCreateSetting is diff
		#nic_keys =[:vlanId,:vlanOperation,:ip, :subnetmask, :gateway, :tagId, :ethCode]
	
		hash_root = :createVMRequest
		vm_hash = params.clone

		#find subnetid by containnername
		container_name = params[:containerName]
		container = CmpOwnercontainer.find_by name: container_name
		subnetid = container.subnetid

		#find nic info
		nic_num = params[:nicnum]
		tagname = "SERVICE_NETWORK"
		#handle_nic nic_num,container,opration,opts
		nic_array = handle_nic nic_num,container,3,:tagname => tagname

		cptpoolid_array = get_cptpoolidlist_by_subnetid subnetid

    vm_ahash =[{:root => 'nicCreateSetting',:array => nic_array},
               {:root => 'cptpoolIdList',:array => cptpoolid_array}]
		vm_hash[:memorySize] = {:value => vm_hash[:memorySize], :unit => 'MB'}
		vm_hash[:diskSize] = {:value => vm_hash[:diskSize], :unit => 'GB'}
		
		owner = container.owner
		vm_hash[:owner] = owner

		#externalid
		vm_hash[:externalId] ||= 'vm_externalId'

		vm_hash.keep_if { |k,v| vm_keys.include? k }
		
		#rest apply vm
		req,res = Connection.restreq method,path,{hash_root => vm_hash},true,vm_ahash

		render xml: {:req => req.body ,:res => res.body}

	end

	def task
		taskid = params[:taskid]
		req,res = get_task_progress taskid
    render xml: res.body
	end

	def update
		#receive params
		vm_name = params[:vmName]
		vguest = CmpVguest.find_by name: vm_name

		method = :put
		vmId = vguest.id
		path = "/compute/vm/manage/#{vmId}"

		vm_keys =[:name, :cpuNum, :memorySize,:diskSize,:scsiNum ,
			        :fchbaNum,:osName,:nicModifySetting,:owner,:description]
		#cptpoolIdList is diff
		#nic_keys = [:vlanId,:vlanOperation,:ip, :subnetmask, :gateway, 
		#            :tagId, :ethCode,:vServerAdapterId ,:nicOperation]

		hash_root = :modifyVMRequest
		vm_hash = params.clone

		container_name = params[:containerName]
    container = CmpOwnercontainer.find_by name: container_name
    subnetid = container.subnetid
    cptpoolid_array = get_cptpoolidlist_by_subnetid subnetid
    vm_ahash =[{:root => 'cptpoolIdList',:array => cptpoolid_array}]
    owner = container.owner
    vm_hash[:owner] = owner

		nic_opration = params[:nicOpration]
    if (0..1).include? nic_opration
      tagname = "SERVICE_NETWORK"
      nic_array = handle_nic 1,vguest,nic_opration,:tagname => tagname
		  vm_hash[:nicModifySetting] = nic_array[0]
    end
		#handle_nic nic_num,container,opration,opts
		vm_hash[:memorySize] = {:value => vm_hash[:memorySize], :unit => 'MB'}
		vm_hash[:diskSize] = {:value => vm_hash[:diskSize], :unit => 'GB'}
		vm_hash.keep_if { |k,v| vm_keys.include? k }
		req,res = Connection.restreq method,path,{hash_root => vm_hash},true,vm_ahash
		render xml: {:req => req.body ,:res => res.body}
	end

	def detail
		method = :get
		vguestname = params[:vguestName]
		vguest = CmpVguest.find_by name: vguestname
		vmId = vguest.id
		path = "/compute/vm/manage/#{vmId}"
		req,res = Connection.restreq method, path, nil,true
		render xml: {:req => req.body ,:res => res.body}
	end

	def get_ticket
		method = :get
		vguestname = params[:vguestName]
		vguest = CmpVguest.find_by name: vguestname
		vmId = vguest.id
		path = "/compute/vm/ticket/#{vmId}"
		req,res = Connection.restreq method, path, nil,true
		render xml: {:req => req.body ,:res => res.body}
	end

	def vm_operate
		method = :post
		path = "/compute/vm/operate"

		vguestname = params[:vguestName]
		vguest = CmpVguest.find_by name: vguestname
		vmId = vguest.id

		actType = params[:actType]

		hash_root = :operateVMRequest

		operate_hash = {:vmId => vmId, :actType => actType}

		req,res = Connection.restreq method, path, {hash_root => operate_hash},true
		render xml: {:req => req.body ,:res => res.body}
	end

	def remove
		method = :delete
		vguestname = params[:vguestName]
		vguest = CmpVguest.find_by name: vguestname
		vmId = vguest.id
		path = "/compute/vm/manage/#{vmId}"

		req,res = Connection.restreq method, path, nil,true
		#req,res = handle_request :remove,:vguestname => vguestname
		#
		render xml: {:req => req.body ,:res => res.body}
	end

	def query_all
		containername = params[:containerName]
		container = CmpOwnercontainer.find_by name: containername
		all_vms = find_all_vms container.owner
		render xml: all_vms
	end

	def query_group
		containername = params[:containerName]
		container = CmpOwnercontainer.find_by name: containername
		group_vms = find_all_vms container.owner,true
		render xml: group_vms
	end

	private

	def handle_request action,opts
		vguestname = opts[:vguestName]
		vguest = CmpVguest.find_by name: vguestname
		vmId = vguest.id
		actions ={:detail =>{:method => :get , :path =>"/compute/vm/manage/#{vmId}"},
		          :get_ticket =>{:method => :get, :path => "/compute/vm/ticket/#{vmId}"},
							:vm_operate =>{:method => :post, :path =>"/compute/vm/operate"},
							:remove => {:mehthod => :delete ,:path => "/compute/vm/manage/#{vmId}"}}
		rest_hash = nil
		if opts.include? :post
			rest_hash = opts[:post]
			rest_hash[:vmId] = vmId
		end
		method = actions[action][:method]
		path = actions[action][:path]
		req,res = Connection.restreq method, path, rest_hash,true
	end

	# create add remove
	#   3     0     1
	# container is yewuxitong when create ,else is vm
	def handle_nic nic_num,container,opration,opts = nil
		nic_array = []
		nic_operation = opration
		(0...nic_num).each do |nic|
      nic_hash = {} 
		  if nic_operation == 3
			 	vlanId ||= container.vlanid
			 	nic_hash[:vlanId] = vlanId
			 	nic_hash[:vlanOperation] = 1
			 	req,res = apply_ip :vlanId => vlanId, :type =>4
			 	ip_xml = res.body
			 	ip_hash = Hash.from_xml ip_xml
			  ip = ip_hash['vlanIpResponse']
			  # ip 
			  nic_hash[:ip] = ip
			  vlan_entry ||= CmpVlanentry.find_by vlanid: vlanId
			  nic_hash[:subnetmask] = vlan_entry.subnetmask
			  nic_hash[:gateway] = vlan_entry.gateway
			  nic_hash[:tagId] = get_tagid_by_names opts[:tagName]
			  nic_hash[:ethCode] = "eth#{nic}"
			else
			  nic_hash[:nic_operation] = nic_operation
        if nic_operation ==0
           nic_hash[:tagId] = get_tagid_by_names opts[:tagname]
        end
			  if nic_operation ==1
				  serverid = container.id    # here container is vm
				  vServerAdapter = CmpVserveradapter.find_by serverid: serverid, servertype: 2, adaptertype: 3
				  nic_hash[:vServerAdapterId] = vServerAdapter.id
			  end				
			end
			  nic_array << nic_hash
		end
    nic_array
  end
		
  def find_all_vms owner,needgroup = false
		all_vms = CmpVguest.where owner: owner
		return all_vms unless needgroup
		group_vms = []
		all_vms.each do |vm|
			vserveradapter = CmpVserveradapter.find_by serverid: vm.id, servertype: 2, adaptertype: 3
			networkcptip = CmpNetworkcptip.find_by adapterid: vserveradapter.id ,servertype: 2
			vm_ip = networkcptip.ip
			vlanip = CmpVlanip.find_by ip: vm_ip , type: 4
			vlan_id = vlanip.vlanid
			ownercontainer = CmpOwnercontainer.find_by vlanid: vlan_id
			group_vms << {:container => ownercontainer, :vm => vm}
		end
		return group_vms
	end
end
