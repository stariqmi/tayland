require_relative "county"

Dir.chdir 'MLS Cash Buyers' # Navigate to the main directory holding all county folders

mlsDir = Dir.pwd

Dir.entries(mlsDir).each do |dir|   # Loop through all valid county folders
  if dir.include? 'County'  # If the folder is a County folder
    puts "\nEntering the '#{dir}' folder ... \n\n"
    Dir.chdir "#{mlsDir}/#{dir}"  # Navigate to the County folder in iteration
    county = County.new Dir.pwd
    Dir.chdir "../"
  end
end