require_relative "excel_parser"
require_relative "pdf_parser"

Dir.chdir 'MLS Cash Buyers' # Navigate to the main directory holding all county folders

mlsDir = Dir.pwd

Dir.entries(mlsDir).each do |dir|   # Loop through all valid county folders
  if dir.include? 'County'  # If the folder is a County folder
    puts "\nEntering the '#{dir}' folder ... \n\n"
    Dir.chdir "#{mlsDir}/#{dir}"  # Navigate to the County folder in iteration
    Dir.entries(Dir.pwd).each do |f|  # Loop through all files inside the County folder
      if f.include? 'pdf'
        puts "\t #{f}"
        pdf = PDF_Parser.new f
      elsif f.include? 'xlsx'
        puts "\t #{f}"
        excel = EXCEL_Parser.new f
      end
    end
    Dir.chdir "../"
  end
end