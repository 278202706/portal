require 'net/http'
require 'uri'

module HttpHelper
	class Connection
		VERB_MAP = {
			:get    => Net::HTTP::Get,
			:post   => Net::HTTP::Post,
			:put    => Net::HTTP::Put,
			:delete => Net::HTTP::Delete
		}
		API_ENDPOINT = 'http://10.1.70.86:8080'
		BASE_PATH ='/rps-service-api/1.0/cmp/module'

		attr_reader :http ,:base_path

		def initialize(endpoint = API_ENDPOINT)
			uri = URI.parse(endpoint)
			@base_path = BASE_PATH
			@http = Net::HTTP.new(uri.host, uri.port)
		end

		def request method , path , params , needxml = false, array_hash = nil
			case method
			when :get
				full_path = path_with_params(base_path + path, params)
				req = VERB_MAP[method].new(full_path)
			else
				req = VERB_MAP[method].new(base_path + path)
				unless needxml
					req.set_form_data(params)
				else
					req.body = hash2xml params,array_hash
				end
			end
		 # logger = ActiveSupport::TaggedLogging.new(Logger.new('cmp.log'))
     # logger.tagged("CMP_req") { logger.info "[#{Time.now}]--#{req.body}" }
     # logger.tagged("CMP_res") { logger.info "#{(http.request req).body}" }
     res = http.request req
     WORKER_LOG.info "[request::method ]--#{req.method}"
     WORKER_LOG.info "[request::path ]--#{req.path}"
     WORKER_LOG.info "[request::body ]--#{req.body}" 
     WORKER_LOG.info "[response::body]--#{res.body}"
	 	  [req , res]
		end

		def self.restreq method,path,params,needxml = false,array_hash = nil
			con = self.new
			con.request method,path,params,needxml,array_hash
		end
	private
		def path_with_params(path, params)
      return path if params.nil?
			encoded_params = URI.encode_www_form(params)
			[path, encoded_params].join("?")
		end

		def hash2xml hash,ahash
			return nil unless hash
			root = hash.keys[0]
			hash_data = hash[root]
			xml = hash_data.to_xml(:root => root)
			return xml if ahash.nil? || !(ahash.is_a? Array)


      ahash.each do |e|
        #array to xml
        ahash_root = e[:root]
        array = e[:array]
        array_xml = array.to_xml(:skip_types => true,:root => ahash_root)
        length = ahash_root.size
        array_xml = array_xml[(length+42)..-(5+length)]
        
        #add array xml
        doc = Nokogiri::XML xml 
        add_builder = Nokogiri::XML::Builder.with(doc.at(root)) do |x|
          x << array_xml
        end

        #add xml
        xml = add_builder.to_xml

      end
			return xml
		end


	end
end

