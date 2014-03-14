include HttpHelper
include CmpModelsHelper
include CmpCommonHelper
class Iaas::CmpDropletIpController < ApplicationController

	def index
		all_droplets =  CmpDroplet.all
	  render xml: all_droplets
	end

  def testsya
     say = Iaas::Say.new
     render json: say.bye
  end

	def apply_instance
		#receive params
		name = params[:name]
		managerAccount = params[:managerAccount]
		managerPassword = params[:managerPassword]
		container_name = parasm[:containername]
		externalId = "instance_externalid"
		description = params[:description]

		#droplet_id
		droplet = CmpDroplet.find_by name: droplet_name
		droplet_id = droplet.id
		
		#owner
		container = CmpContainer.find_by name: container_name
		owner = container.owner

		#config build
		install_path = ''
		opts ={}
		config = config_generate install_path,opts


		#rest request
		method = :post
		path = "/software/console/deploy/apply"
		hash_root = :applySoftwareDeployRequest
		instance_hash = {}
		instance_hash[:name] = name
		instance_hash[:dropletId] = droplet_id
		instance_hash[:config] = config
		instance_hash[:managerAccount] = managerAccount
		instance_hash[:managerPassword] = managerPassword
		instance_hash[:owner] = owner
		instance_hash[:externalId] = externalId
		instance_hash[:description] = description

		req,res = Connection.restreq method,path,{hash_root => instance_hash},true
		render xml: {:req => req.body ,:res => res.body}
	end

	def add_deploy
		#receive params
		instance_name = params[:instanceName]
		vm_name = params[:vmName]

		#rest request
		method = :post		
		hash_root = :addSoftwareDeployOperatorRequest
		req,res = handle_deploy method,instance_name,vm_name,:hash_root => hash_root,:resourceType => true
		render xml: {:req => req.body ,:res => res.body}
	end

	def remove_deploy
		#receive params
		instance_name = params[:instanceName]
		vm_name = params[:vmName]

		#rest request
		method = :put
		hash_root = :removeSoftwareDeployOperatorRequest
		req,res = handle_deploy method,instance_name,vm_name,:hash_root => hash_root
		render xml: {:req => req.body ,:res => res.body}
	end

	def query_deploy_status
		#receive params
		instance_name = params[:instanceName]
		vm_name = params[:vmName]

		#instance id
		instance = CmpSoftwareinstance.find_by name: instance_name
		instance_id = instance.id

		#vm id 
		vguest = CmpVguest.find_by name: vm_name
		resourceId = vguest.id

		path = "/software/console/deploy/query/#{instance_id}/#{resourceId}"
		method = :get
		req,res = Connection.restreq method,path,nil
		render xml: {:req => req.body ,:res => res.body}
	end

	def cancel_instance
		#receive params
		instance_name = params[:instanceName]

		#instance id
		instance = CmpSoftwareinstance.find_by name: instance_name
		instance_id = instance.id

		#rest request
		method = :delete
		path = "/software/console/deploy/cancel/#{instance_id}"
		req,res = Connection.restreq method,path,nil,true
		render xml: {:req => req.body ,:res => res.body}
	end

	private
	def handle_deploy mehtod,instance_name,vm_name,opts
		#instance id
		instance = CmpSoftwareinstance.find_by name: instance_name
		instance_id = instance.id

		#vm id
		vguest = CmpVguest.find_by name: vm_name
		resourceId = vguest.id

		#path
		path = "/software/console/deploy/resource"

		#rest request
		hash_root = opts[:hash_root]
		resourceInfo[:resourceId] = resourceId
		resourceInfo[:resourceType] = 1  if opts[:resourceType]
		deploy_hash = {:softwareInstanceId => instance_id,
			:resourceInfo =>resourceInfo
		}
		req,res = Connection.restreq method,path,{hash_root => deploy_hash},true		
	end

	def config_generate install_path,opts
		hash_root = :ConfigMsg
		config_hash = {:Install_Path => install_path}
		base_xml = config_hash.to_xml(:root => hash_root)

		return base_xml if opts.empty? || opts[0].empty?
		#array chuli
		opts = [opts] unless opts.is_a? Array
		array_builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
			xml.root do
				opts.each do |e|
					e.each do |k,v|
						xml << "<Specific_Settings name=\"#{k}\">#{v}<\/Specific_Settings>"
					end
				end
			end
		end
		array_xml = array_builder.to_xml

		#add to base
		doc = Nokogiri::XML base_xml
		xml_builder = Nokogiri::XML::Builder.with(doc.at(hash_root)) do |xml|
			xml << array_xml[46..-9]
		end
		conf_xml = xml_builder.to_xml
	end
end
