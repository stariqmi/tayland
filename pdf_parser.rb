require 'rubygems'
require 'nokogiri'

class PDF_Parser

	attr_reader :properties

	def initialize filename
		system "../../pdftohtml -xml -q \"#{filename}\" pdf"
		xml = Nokogiri::XML File.open("pdf.xml")
		@properties = getProperties xml
	end

	def getProperties xml
		props = []
		pages = xml.xpath("//page")
		pages.each do |page|
			property = {}
			elems = page.xpath(".//text/b[contains(text(), 'Property Address')]/../following-sibling::*")
			property["propertyAddr"] = elems[0].text
			elems = page.xpath(".//text/b[contains(text(), 'Owner')]/../following-sibling::*")
			property["owner"] = elems[0].text
			elems = page.xpath(".//text/b[contains(text(), 'Tax Mailing Address')]/../following-sibling::*")
			property["taxAddr"] = elems[0].text
			props << property
		end
		props
	end
end