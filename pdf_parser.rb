require 'rubygems'
require 'nokogiri'

class PDF_Parser

	attr_reader :properties

	def initialize filename
		system "../../pdftohtml -xml -q \"#{filename}\" pdf"	# Uses exe application to convert to xml
		xml = Nokogiri::XML File.open("pdf.xml")	# Nokogiri to open xml
		@properties = getProperties xml
		@properties
	end

	def getProperties xml
		props = []
		pages = xml.xpath("//page")

		# Parse each page using xpath
		pages.each do |page|
			property = {}
			elems = page.xpath(".//text/b[contains(text(), 'Property Address')]/../following-sibling::*")
			property[:propertyAddr] = elems[0].text
			elems = page.xpath(".//text/b[contains(text(), 'Owner')]/../following-sibling::*")
			property[:owner] = elems[0].text
			elems = page.xpath(".//text/b[contains(text(), 'Tax Mailing Address')]/../following-sibling::*")
			property[:taxAddr] = elems[0].text
			property[:owns] = if property[:taxAddr] == property[:propertyAddr]
				1 
			else 
				0
			end
			props << property
		end
		props
	end
end