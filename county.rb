require_relative "excel_parser"
require_relative "pdf_parser"

require 'spreadsheet'

class County

	attr_accessor :excelProperties, :mainRows

	def initialize dir
		@pdfProperties = []
		@excelProperties = []
		@filteredProperties = []
		@mainRows = []
		Dir.entries(dir).each do |f|  # Loop through all files inside the County folder
		    if f.include? 'pdf'
			    pdf = PDF_Parser.new f
			    @pdfProperties.concat pdf.properties
			elsif f.include? 'xlsx'
			    excel = EXCEL_Parser.new f
			    @excelHeaders = excel.headers
			    @excelProperties.concat excel.properties
	      	end
    	end
    	@headers = ["Tax Address", "Tax City", "Tax Zip"].concat @excelHeaders
		@mainRows << @headers
	end

	def matchProperties
		@excelProperties.each do |property|
			propertyAddr = property[3].strip
			puts propertyAddr
			@pdfProperties.each do |p|
				puts "\t#{p[:propertyAddr]}"
				if p[:propertyAddr].include? propertyAddr
					taxArray = getTaxAddress p
					@filteredProperties << {pdf: taxArray, excel: property}
					break
				end
			end
		end
	end

	def print
		puts "#{@filteredProperties.count} filtered properties"
		@filteredProperties.each do |prop|
			puts "PDF => #{prop[:pdf].inspect}"
			puts "EXCEL => #{prop[:excel].inspect}"
		end
	end

	def getTaxAddress property
		arr = []
		addray = property[:propertyAddr].split
		arr << (addray[0..-3].join " ")
		arr << addray[-2]
		arr << addray[-1]
		arr << property[:owns]
		arr
	end

	def createXLS
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet :name => "filtered"
		i = 1
		sheet.update_row 0, *@headers
		@filteredProperties.each do |property|
			property[:excel].slice! 0
			row = property[:pdf].concat property[:excel]
			@mainRows << row
			sheet.update_row i, *row
			i += 1
		end
		book.write 'properties.xls'
	end
end