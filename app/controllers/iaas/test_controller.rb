class Iaas::TestController < ApplicationController
	include TestHelper
	def index
		#number =  User.find_first
		#met = User.find_by_sql("select * from cmp_owner")    #methods
		#met = User.all
		#info = get_info
		info = "dsfa"
		render json: info

	end

	def testarray
		array = [
			{ :name => 'rer',:age =>1234}, 
			{ :name =>"ADFAD" ,:age => 124 },
			{:test => "erewr"}
		]
		root = "testroot"
		xml = array.to_xml(:skip_types => true,:root => root)
		length = root.size
		puts xml[(length+42)..-(5+length)]
		render xml: xml
	end

	def testadd
		hash = {:a =>{:b => "adfadsf",:name => "adfadf"},
			      :length =>14
		}
		xml = hash.to_xml(:root => "testadd")

		array = [
			{ :name => 'rer',:age =>1234},
			{ :name =>"ADFAD" ,:age => 124 },
			{:test => "erewr"}
		]
		root = "testroot"
		arxl = array.to_xml(:skip_types => true,:root => root)
		length = root.size
		arra_xml = arxl[(length+42)..-(5+length)]


		doc = Nokogiri::XML xml
		p doc
		newxml = Nokogiri::XML::Builder.with(doc.at('testadd')) do |x|
			x << arra_xml
		end

		newxml = newxml.to_xml
		#render xml: {:old => xml, :new => newxml}
		render xml: newxml
	end

	def testall
		hash = [{ :name => 'rer',:age =>1234}, { :name =>"ADFAD" ,:age => 124 }]
		builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
			
			xml.root do
			hash.each do |e|
				e.each do |k,v|
					#xml.root('name'=> k) v
					xml << "<ba name = \'#{k} \'>#{v}<\/ba>"
				end
				end
			end
		end
		xml = builder.to_xml
		render xml: xml
	end

	def testxml
		hash = [
		  { :name => 'rer',:age =>1234},
			{ :name =>"ADFAD" ,:age => 124 },
			{:test => "erewr"}
		
		]
    builder = Nokogiri::XML::Builder.new do |xml|
			xml.shipment do
				hash.each do |e| 
		#			xml.age e[:age]
		#			xml.name e[:name]
					e.each do |k,v|
						xml.text "<#{k}>#{v}<\/#{k}>"   #cdata k
					#	xml << "<#{k}>#{v}<\/#{k}>"   #cdata k
						#xml.text v
						#xml.node xml.methods
					end
				end
			end
		end
		#render xml: hash.to_xml(lambda { |options, key| options[:builder].b(key) })
		xml = builder.to_xml
		puts xml[22..-1]
		render xml: xml[22..-1]
		#render xml: (hash.to_xml :root => 'msms')
	end
  def test
		hash ={:rootnode => {:name => "xuxiaolong",:age =>24}}
		array ={:root => "arrayroot",:array =>[{:yuwen => 87},{:shuxue => 89}]}
		xml = testhash2xml hash,array
		render xml: xml
	end
	def testhash2xml hash,ahash
		return nil unless hash
		root = hash.keys[0]
    hash_data = hash[root]
			xml = hash_data.to_xml(:root => root)
			return xml if ahash.nil? || ahash[:array].empty?

			#array to xml
			ahash_root = ahash[:root]
			array = ahash[:array]
			array_xml = array.to_xml(:skip_types => true,:root => ahash_root)
			length = ahash_root.size
			array_xml = array_xml[(length+42)..-(5+length)]

			#add array xml
			doc = Nokogiri::XML xml 
			add_builder = Nokogiri::XML::Builder.with(doc.at(root)) do |x|
				x << array_xml
			end
			
			#add xml
			add_xml = add_builder.to_xml


	end
end
