require_relative "county"
require 'spreadsheet'

Dir.chdir 'MLS Cash Buyers' # Navigate to the main directory holding all county folders

mlsDir = Dir.pwd
properties = []

Dir.entries(mlsDir).each do |dir|   # Loop through all valid county folders
    if dir.include? 'County'  # If the folder is a County folder
        puts "\nEntering the '#{dir}' folder ... \n\n"
        Dir.chdir "#{mlsDir}/#{dir}"  # Navigate to the County folder in iteration
        county = County.new Dir.pwd
        county.matchProperties
        county.print
        county.createXLS
        properties.concat county.mainRows
        Dir.chdir "../"
    end
end



book = Spreadsheet::Workbook.new
sheet = book.create_worksheet :name => "filtered"
i = 0
properties.each do |property|
    sheet.update_row i, *property
    i += 1
end
book.write 'main_properties.xls'