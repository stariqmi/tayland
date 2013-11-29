require_relative "excel_parser"
require_relative "pdf_parser"

require 'spreadsheet'

class County

	attr_accessor :excelProperties, :mainRows

	def initialize dir

		# Initializing instance variables
		@pdfProperties = []
		@excelProperties = []
		@filteredProperties = []
		@mainRows = []

		Dir.entries(dir).each do |f|  # Loop through all files inside the County folder
		    if f.include? 'pdf'	# If a pdf file
			    pdf = PDF_Parser.new f
			    @pdfProperties.concat pdf.properties
			elsif f.include? 'xlsx'	# If an xlsx file
			    excel = EXCEL_Parser.new f
			    @excelHeaders = excel.headers
			    @excelProperties.concat excel.properties
	      	end
    	end
    	# Create headers for main xls file
    	@headers = ["Tax Address", "Tax City", "Tax Zip"].concat @excelHeaders
		@mainRows << @headers 
	end

	# Matches properties in xlsx to properties in pdf 
	# if match found, added to @filteredProperties else ignored
	def filterProperties

		# Loop through all properties in the xlsx file
		@excelProperties.each do |property|
			propertyAddr = property[3].strip	# Get the address
			@pdfProperties.each do |p|	# Loop through all the properties in the pdf file
				if p[:propertyAddr].include? propertyAddr	# If xlsx address is a part of pdf address
					# Add details in a specific format to @filteredProperties
					taxArray = getTaxAddress p
					@filteredProperties << {pdf: taxArray, excel: property}
					break
				end
			end
		end
	end

	# Helper function to print properties
	def print
		puts "#{@filteredProperties.count} filtered properties"
		@filteredProperties.each do |prop|
			puts "PDF => #{prop[:pdf].inspect}"
			puts "EXCEL => #{prop[:excel].inspect}"
		end
	end

	# Extracts the tax Address from the pdf information
	def getTaxAddress property
		arr = []
		addray = property[:propertyAddr].split
		arr << (addray[0..-3].join " ")
		arr << addray[-2]
		arr << addray[-1]
		arr << property[:owns]
		arr
	end

	# Creates an XLS file from all the @filteredProperties
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