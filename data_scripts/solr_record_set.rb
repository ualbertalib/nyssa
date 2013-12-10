require_relative("marc_records")

class SolrRecordSet

  attr_reader :list, :raw_match_data

  def initialize(data_file, match_data_file)
    @list = {}
    @raw_match_data = []
    load_marc_records(data_file)
    load_match_data(match_data_file)
    match!
  end

  def to_xml
    xml_record = %[<xml version="1.0" encoding="UTF-8"?><add>]
      @list.each do |key, value|
        xml_record += value.to_xml
      end
    xml_record += %[</add>]
  end

  def to_solr(solr_file)
    File.open(solr_file, "w"){|f|
      f.puts self.to_xml
    }
  end
  private

  def load_marc_records(data_file)
    @list = process(MarcRecords.new(data_file))
  end

  def process(marc_records)
    list = {}
    marc_records.list.each do |record|
      list.merge!(record.issn => record)
    end
    list
  end

  def load_match_data(data_file)
    data_file.each_line do |line|
      @raw_match_data << line
    end
  end

  def match!
    @raw_match_data.each do |match|
      data = match.split("|")
      issn = data[2].chomp
      statement = data[3].chomp
      @list[issn].set_match(updated?(statement), statement) if @list[issn] 
    end
  end

  def updated?(statement)
    statement.include?("Not updated") ? false : true
  end
end
