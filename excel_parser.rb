require 'rubygems'
require 'simple_xlsx_reader'

class EXCEL_Parser
  
  attr_accessor :properties

  def initialize filename
    excelDoc = SimpleXlsxReader.open filename
    sheet = findSheetByName "Tax Import", excelDoc
    @properties = getProperties sheet
  end

  def findSheetByName name, excelDoc
    excelDoc.sheets.each do |sheet|
      return sheet if sheet.name == name
    end
  end

  def getProperties sheet
    rows = []
    sheet.rows.each do |row|
      rows << row if isNotEmpty row
    end
    rows 
  end

  def isNotEmpty row
    check = false
    row.each do |field|
      return true unless field.nil?
    end
    check
  end

end