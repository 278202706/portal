include HttpHelper
include CmpModelsHelper

module CmpCommonHelper
	
	#for cptpoolIdList(hash) 
	def get_cptpoolidlist_by_subnetid subnetid
		method = :get
		path = "/compute/cptpoolidlist/#{subnetid}"
		req,res = Connection.restreq method, path, nil,true
    body = res.body
    return [] if body.nil?
    idlist_hash = Hash.from_xml body
    root = idlist_hash.keys[0]
    idlist = []
    idlist_array = idlist_hash[root]
    idlist_array = [idlist_array] unless idlist_array.is_a? Array
    idlist_array.each do |id|
      id.each do |k,v|
        idlist << v
      end
    end
		#res type need handle
    return idlist
	end


	#for tagid
	#group name only ("networktype") accessible
	def get_tagid_by_names tagname, groupname = "NETWORKTYPE"
		selector = {:name => tagname}
		taggroup = CmpTaggroup.find_by name: groupname
		selector[:groupid]= taggroup.id 
		tags = CmpTag.where(selector).all

		tags   #[1].id
	end

	def get_task_progress taskid
		method = :get
		path = "/common/task/#{taskid}"
		req,res = Connection.restreq method, path, nil,true
	end


end
