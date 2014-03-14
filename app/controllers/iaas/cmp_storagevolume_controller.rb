include HttpHelper
class Iaas::CmpStoragevolumeController < ApplicationController

	def index
		storagevolume = CmpStoragevolume.all
		render xml: storagevolume
	end
	
	def create
		method = :post
		path = '/storage'

		key_array = [:storageName, :storageNet,:description,
		             :tier, :tierOpen, :raid,:owner,
		             :resourceType,:capacity]

		storage_hash = params.clone
		owner = CmpOwner.find_by ownername: storage_hash[:ownerName]
		storage_hash[:owner] = owner.owner
		storage_hash[:capacity] = {:value =>storage_hash[:capacityValue], :unit => storage_hash[:capacityUnit]}

		storage_hash.keep_if {|k,v| key_array.include? k}
		hash_root = :createStorageRequest
		
		req,res = Connection.restreq method,path,{hash_root => storage_hash},true
		render xml: {:req => req.body ,:res => res.body}
	end

	#update, search, delete
	def manage
		method = params[:behavior].to_sym
		
		storage_name = params[:name]
		storage = CmpStoragevolume.find_by name: storage_name

		storage_id = storage.id
		path = "/storage/manage/#{storage_id}"
		manage_hash = nil
		if method == :put
			owner = CmpOwner.find_by ownername: storage_hash[:ownerName]
			manage_hash = {:modifyStorageRequest => {
			                 :newSize => params[:newSize],
			                 :newName => params[:newName],
			                 :owner => owner.owner,
			                 :description => params[:description]
			              }}
		end
		req,res = Connection.restreq method,path,manage_hash,true

		render xml: {:req => req.body ,:res => res.body}

	end

	#relevance
	def relevance
		method = :get
		storage_name = params[:name]
		storage = CmpStoragevolume.find_by name: storage_name
		storage_id = storage.id
		path = "/storage/relevance/#{storage_id}"
		
		req,res = Connection.restreq method,path,nil,true

		render xml: {:req => req.body ,:res => res.body}
	end

	#guazai xiezai
	def attach
		method = params[:behavior].to_sym

		storage_id = find_storage_id_by_name params[:storageName]
		host_id = find_guest_id_by_name params[:hostName]

		path ="/storage/attach/#{storage_id}/#{host_id}"
		
		req,res = Connection.restreq method,path,nil,true
		render xml: {:req => req.body ,:res => res.body}
	end

	def query_by_ownername
		ownername = params[:id]
		owner = CmpOwner.find_by ownername: ownername
		storages = CmpStoragevolume.where owner: owner.owner
		render xml: storages
	end

end

