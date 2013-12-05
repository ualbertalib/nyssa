require_relative("marc_records")

class SolrRecordSet

  attr_reader :list, :raw_match_data

  def initialize
    @list = {}
    @raw_match_data = []
  end

  def load_marc_records(data_file)
    # I've never really liked this. Definitely a candiate for refactoring
    # to get rid of the dependency
    marc_records = MarcRecords.new
    marc_records.load_data(data_file)
    marc_records.list.each do |record|
      r = Record.new
      r.marc_record = record
      @list[r.issn] = r
    end
    add_supplementary_data
  end

  def load_match_data(data_file)
    File.open(data_file).each_line do |line|
      @raw_match_data << line
    end
  end

  def match!
    @raw_match_data.each do |match|
      data = match.split("|")
      issn = data[2].chomp
      statement = data[3].chomp
      # Here's a dependency: we know #set_match and we know the order of the 
      # parameters. This should definitely be refactored
      @list[issn].set_match(updated?(statement), statement) 
    end
  end

  def to_xml
    xml_record = %[<?xml version="1.0" encoding="UTF-8"?><add>]
      @list.each do |key, value|
        xml_record += value.to_xml
      end
    xml_record += %[</add>]
  end

  def to_solr(solr_file)
    # I need to find the Ruby pattern for this. I'm starting to think passing
    # in file paths for the method to open is wrong.
    File.open(solr_file, "w"){|f|
      f.puts self.to_xml
    }
  end

  private

  def updated?(statement)
    statement.include?("Not updated") ? false : true
  end
  
  def add_supplementary_data
    @list.each do |key,record|
      record.expand!
    end
  end
end
