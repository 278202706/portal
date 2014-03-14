module CmpModelsHelper
	
	#for cmp_lbpool
	def get_lb_by_owner system
		owner = system.owner
		CmpLbpool.find_by owner: owner
	end


	#for cmp_storagevolume
	def find_storage_id_by_name name
		storage = CmpStorage.find_by name: name
		storage.id
	end

	#for cmp_vguest
	def find_guest_id_by_name name
		vguest = CmpVguest.find_by name: name
		vguest.id
	end
	
	
	#for cmp_natip
	def get_natip_by_owner system
		owner = system.owner
		CmpNatip.find_by owner: owner
	end

  #for cmp_ossource
  def get_oslist_by_cptpool cptpool
    selector = {:vdcid => cptpool.vdcid, :srctype => 1, :status =>1}
    oslist = CmpOssource.where selector
  end


end
