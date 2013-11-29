require_relative "excel_parser"
require_relative "pdf_parser"

class County

	def initialize dir
		Dir.entries(dir).each do |f|  # Loop through all files inside the County folder
		    if f.include? 'pdf'
			    puts "\t #{f}"
			    pdf = PDF_Parser.new f
			elsif f.include? 'xlsx'
			    puts "\t #{f}"
			    excel = EXCEL_Parser.new f
	      	end
    	end
	end
end